# frozen_string_literal: true

require 'test_helper'

class BookingsConcernTest < ActiveSupport::TestCase
  include BookingsConcern

  def setup
    create_seed_user
    # Create the current user
    @user = FactoryBot.create(:user, :for_test, :with_couch)
    @host = FactoryBot.create(:user, :for_test, :with_couch, :offers_couch)

    @booking = FactoryBot.build(:booking, user: @user, couch: @host.couch)
  end

  test 'should prepare booking for save' do
    setup_update_params

    booking = prepare_booking_for_save
    assert_equal @host.couch_id, booking.couch_id
    assert_equal @user.id, booking.user_id
    assert_not_nil booking.booking_date
    assert_not_nil booking.start_date
    assert booking.valid?
  end

  test 'should send email after create' do
    @booking.status = :cancelled
    @booking.save!

    mocked_this = Minitest::Mock.new
    mocked_this.expect :call, nil, [@booking]
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      stub(:create_chat_and_message, mocked_this) do
        post_create(@booking)
      end
    end
    assert_equal 'pending', @booking.status
  end

  test 'should send email post update' do
    setup_update_params
    @booking.status = :pending
    @booking.save!

    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      message = post_update(@booking)
      assert_equal 'Request successfully updated!', message
    end
    assert_equal 'pending', @booking.status
  end

  test 'should accept and send email' do
    @booking.status = :pending
    @booking.save!

    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      accept_booking(@booking)
    end
    assert_equal 'confirmed', @booking.status
  end

  test 'should cancel request as guest' do
    @booking.status = :confirmed
    @booking.save!

    message = cancel_booking(@booking)
    assert_equal 'Request successfully cancelled!', message

    assert_equal 'cancelled', @booking.status
  end

  test 'should cancel request as host' do
    @booking = FactoryBot.build(:booking, user: @host, couch: @user.couch)

    message = cancel_booking(@booking)
    assert_equal 'Booking successfully cancelled!', message

    assert_equal 'cancelled', @booking.status
  end

  test 'should not be able to decline event if not host' do
    @booking = FactoryBot.build(:booking, user: @user, couch: @host.couch)

    assert_raise(Exceptions::ForbiddenError) { decline_booking(@booking) }
    assert_equal 'pending', @booking.status
  end

  test 'should decline and send message' do
    @booking = FactoryBot.build(:booking, user: @host, couch: @user.couch)

    assert_difference('Chat.count', +1) do
      decline_booking(@booking, 'Sorry, I cannot host you')
    end
    assert_equal 'declined', @booking.status
  end

  test 'should return update message for confirmed booking' do
    @booking.status = :confirmed
    @booking.save!

    assert_equal 'Booking successfully updated!', post_update(@booking)
    @booking.reload
    assert_equal 'pending', @booking.status
  end

  test 'should create chat and message' do
    assert_difference %w[Chat.count Message.count], +1 do
      create_chat_and_message(@booking)
    end
  end

  test 'should find chat' do
    Chat.destroy_all
    chat = Chat.create(user_sender_id: @user.id, user_receiver_id: @booking.couch.user.id)
    assert_equal chat, find_chat(@user, @booking.couch.user)

    Chat.destroy_all
    chat2 = Chat.create(user_sender_id: @booking.couch.user.id, user_receiver_id: @user.id)
    assert_equal chat2, find_chat(@user, @booking.couch.user)
  end

  private

  def setup_update_params
    params[:booking] = @booking.attributes
    params[:couch_id] = @host.couch_id
  end

  def booking_params
    booking_params = params.require(:booking).permit(:request, :start_date, :end_date, :number_travellers, :message,
                                                     :flexible)
    booking_params.merge(user_id: current_user.id, couch_id: params[:couch_id])
  end
end

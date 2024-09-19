# frozen_string_literal: true

require 'test_helper'

class BookingsConcernTest < ActiveSupport::TestCase
  include BookingsConcern

  def setup
    create_seed_user
    # Create the current user
    @user = FactoryBot.create(:user, :for_test, :with_couch)
    @host = FactoryBot.create(:user, :for_test, :with_couch, :offers_couch)

    @booking = FactoryBot.build(:booking)
    @booking.couch_id = @host.couch_id
    @booking.user_id = @user.id
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

  test 'should process after create' do
    @booking.status = :cancelled
    @booking.save!

    mocked_this = Minitest::Mock.new
    mocked_this.expect :call, nil, [@booking]
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      stub(:create_chat_and_message, mocked_this) do
        after_create_process(@booking)
      end
    end
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

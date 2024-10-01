# frozen_string_literal: true

require 'system_test_helper'

class TripsWorkflowTest < ApplicationSystemTestCase
  setup do
    # modify database to have only one possible host
    User.update_all(offers_couch: false, travelling: true)

    @user = FactoryBot.create(:user, :for_test, :with_couch, :subscribed)
    sign_in_as(@user)

    @host = FactoryBot.create(:user, :for_test, :offers_couch)
    @booking = FactoryBot.create(:booking, user: @user, couch: @host.couch)
    @request = FactoryBot.create(:booking, user: @host, couch: @user.couch)
  end

  test 'should see upcoming trips' do
    visit bookings_path
    assert_selector 'h1', text: 'TRIPS'
    assert_selector 'h2', text: 'Upcoming Trips'
    # check that the past & cancelled trips section is not visible
    assert_no_selector 'h2', text: 'Past Trips'
    assert_no_selector 'h2', text: 'Cancelled, Declined & Expired Trips'

    assert_selector '.upcoming-booking', count: 1

    assert_selector '.upcoming-booking__host', text: @host.first_name.upcase
    assert_selector '.upcoming-booking__request', text: @booking.request.capitalize
    assert_selector '.upcoming-booking__status', text: @booking.status.capitalize
  end

  test 'should find and request a new couch' do
    visit root_path

    assert_selector '.couch-card', count: 1
    first('.couch-card').click

    assert_selector '.couch__name', text: @host.first_name.capitalize

    click_on 'Send Quouch request'
    assert_selector '.booking-form', count: 1
    assert_selector 'label', text: '* REQUEST'
    assert_selector '.booking-form__button', count: 1

    assert_current_path new_couch_booking_path(@host.couch)
  end

  test 'should create a new booking' do
    visit new_couch_booking_path(@host.couch)
    assert_selector '.booking-form', count: 1
    assert_selector '.booking-form__button', count: 1

    select_date('.booking_start_date', 2.days.from_now)
    select_date('.booking_end_date', 3.days.from_now)
    fill_in 'booking[message]', with: 'Hello, I would like to stay at your place.'

    assert_difference 'Booking.count', 1 do
      click_on 'Send Request'

      assert_text 'Your request has been sent!'.upcase
    end

    assert_current_path sent_booking_path(Booking.last)
  end

  test 'should show error message when creating booking without message' do
    visit new_couch_booking_path(@host.couch)

    # make flexible booking
    check 'booking[flexible]'
    fill_in 'booking[message]', with: ''

    click_on 'Send Request'

    assert_selector '.form_error', text: 'can\'t be blank'
  end

  test 'should not be able to duplicate booking' do
    # prepare request data
    request = 'host'
    start_date = 2.days.from_now
    end_date = 3.days.from_now

    @host.offers_couch = true
    @host.save!
    @booking.start_date = start_date
    @booking.end_date = end_date
    @booking.request = request
    @booking.save!

    visit new_couch_booking_path(@host.couch)

    # ensure it's the same request type
    choose request
    select_date('.booking_start_date', start_date)
    select_date('.booking_end_date', end_date)
    fill_in 'booking[message]', with: 'Hello, I would like to stay at your place.'

    click_on 'Send Request'

    assert_selector '.form_error', text: 'Duplicated request with host'
  end

  test 'should edit existing booking' do
    # Delete all other bookings to prevent conflicts
    Booking.where.not(id: @booking.id).destroy_all

    visit booking_path(@booking)
    assert_selector 'h1', text: 'Booking Overview'.upcase
    assert_selector 'h2', text: 'Your Host'

    assert_selector '.booking__details-list > .status', text: @booking.status.capitalize

    click_on 'Update Request'
    assert_selector 'label', text: '* PICK ONE'

    assert_selector '.booking-form', count: 1
    assert_selector '.booking-form__button', count: 1

    choose 'host'
    select_date('.booking_start_date', 3.days.from_now)
    select_date('.booking_end_date', 4.days.from_now)
    fill_in 'booking[message]', with: 'Hello, I would like to stay at your place.'

    assert_no_difference 'Booking.count' do
      click_on 'Send updated request'

      assert_selector 'div.flash', text: 'Request successfully updated!'

      @booking.reload
      assert_equal 3.days.from_now.to_date, @booking.start_date
    end

    assert_current_path booking_path(@booking)
  end

  test 'should show error message when updating booking without message' do
    visit edit_booking_path(@booking)

    # remove message
    fill_in 'booking[message]', with: ''

    click_on 'Send updated request'

    assert_selector '.form_error', text: 'can\'t be blank'
  end

  test 'should not see unaffiliated booking' do
    visit booking_path(@request)
    assert_current_path bookings_path
  end

  test 'should cancel booking as guest' do
    visit booking_path(@booking)
    assert_no_selector 'button', text: 'Decline Request'
    assert_no_selector 'button', text: 'Accept Request'

    click_on 'Cancel Request'

    assert_selector '.swal-modal'
    assert_selector '.swal-title', text: 'Confirm'

    click_on 'Yes, cancel'

    assert_selector 'div.flash', text: 'Request successfully cancelled!'
    assert_current_path bookings_path

    assert_selector '.upcoming-booking', count: 0
    assert_selector '.past-booking', count: 1
  end
end

# frozen_string_literal: true

require 'system_test_helper'

class RequestsWorkflowTest < ApplicationSystemTestCase
  setup do
    @user = FactoryBot.create(:user, :for_test, :with_couch, :subscribed)
    sign_in_as(@user)

    @host = FactoryBot.create(:user, :for_test, :offers_couch)
    @booking = FactoryBot.create(:booking, user: @user, couch: @host.couch)
    @request = FactoryBot.create(:booking, user: @host, couch: @user.couch)
  end

  test 'should decline booking as host' do
    visit request_booking_path(@request)
    assert_no_selector 'button', text: 'Cancel Request'
    click_on 'Decline Request'

    assert_selector '.swal-modal'
    assert_selector '.swal-title', text: 'Confirm'

    click_on 'Yes, decline'

    assert_selector 'div.flash', text: 'Request has been declined.'
    assert_current_path requests_couch_bookings_path(@user.couch)

    assert_selector '.upcoming-request', count: 0
    assert_selector '.past-request', count: 1
  end

  test 'should accept booking as host' do
    visit request_booking_path(@request)
    assert_no_selector 'button', text: 'Update Request'

    click_on 'Accept Request'

    assert_selector '.swal-modal'
    assert_selector '.swal-title', text: 'Request accepted!'
    click_on 'Ok!'

    assert_current_path request_booking_path(@request)
    assert_selector '.booking__details-list > .status', text: 'Confirmed'
  end
end

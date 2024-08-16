require 'system_test_helper'

class CookiesTest < ApplicationSystemTestCase
  test 'should have a cookies page' do
    visit cookies_url

    assert_selector 'h1', text: 'COOKIES'
  end

  test 'should see cookies banner' do
    visit root_path
    assert_selector '.cookies-eu', count: 1
    assert_selector '.cookies-eu-content-holder', text: 'you agree to our use of cookies'
    assert_selector '.cookies-eu-ok', text: 'OK'
    assert_selector '.cookies-eu-link', text: 'Learn more'
  end

  test 'should navigate to cookies page' do
    visit root_path

    find('.cookies-eu-link').click
    # Check that a new tab was opened and switch to it
    assert_equal 2, page.driver.browser.window_handles.size
    page.driver.browser.switch_to.window(page.driver.browser.window_handles.last)

    assert_selector 'h1', text: 'COOKIES'
  end

  test 'should close cookies banner' do
    visit root_path
    find('.cookies-eu-ok').click
    assert_no_selector '.cookies-eu'

    # Check that the banner is not shown after refreshing the page
    page.refresh
    assert_no_selector '.cookies-eu'
  end
end

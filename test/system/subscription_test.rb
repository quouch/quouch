# frozen_string_literal: true

require 'system_test_helper'

module SubscriptionTestHelper
  def prepare_data
    @user = FactoryBot.create(:user, :for_test, :with_couch)
    sign_in_as(@user)

    @host = FactoryBot.create(:user, :for_test, :offers_couch)
    @booking = FactoryBot.create(:booking, :pending, user: @user, couch: @host.couch)
  end
end

module SubscriptionTest
  class UnsubscribedUserTest < ApplicationSystemTestCase
    include SubscriptionTestHelper
    setup do
      prepare_data
    end

    test 'should see `Join now` in dropdown menu' do
      visit root_path

      find('#dropdown_menu').click

      assert_selector 'a', text: 'Join now'
    end

    test 'should not fail if user is not subscribed' do
      # There's a bug where people get a link to the subscription page of another user
      # This test is to make sure that the page doesn't break when that happens
      another_user = FactoryBot.create(:user, :for_test, :with_couch, :subscribed)
      visit subscription_path(another_user.subscription)
      assert_selector '.plans__list-item', count: 1
      assert_selector '.plans__list-item.current-plan', count: 0
    end

    test 'should navigate to new subscription page' do
      skip 'This test should only be used on desktop' if mobile?

      visit root_path

      find('a', text: 'Membership'.upcase).click

      assert_selector 'h1', text: 'Choose a plan'.upcase
      assert_current_path new_subscription_path
    end

    test 'should be asked to subscribe when trying to book' do
      visit couch_path(@host.couch)

      click_on 'Send Quouch request'

      assert_selector 'h1', text: 'Choose a plan'.upcase
      assert_current_path new_subscription_path
    end

    test 'should be asked to subscribe when trying to message user' do
      visit couch_path(@host.couch)

      find('.couch__chat').click

      assert_selector 'h1', text: 'Choose a plan'.upcase
      assert_current_path new_subscription_path
    end
  end

  class SubscribedUserTest < ApplicationSystemTestCase
    include SubscriptionTestHelper
    setup do
      prepare_data
      FactoryBot.create(:plan, user: @user)
    end

    test 'should see `Your Membership` in dropdown menu' do
      visit root_path

      find('#dropdown_menu').click

      assert_no_selector 'a', text: 'Join now'
      assert_selector 'a', text: 'Your Membership'
    end

    test 'should navigate to my subscription page' do
      skip 'This test should only be used on desktop' if mobile?

      visit root_path

      find('a', text: 'Membership'.upcase).click

      assert_selector 'h1', text: 'Manage Membership'.upcase
      assert_current_path subscription_path(@user.subscription)
    end

    test 'should not be asked to subscribe when trying to book' do
      visit couch_path(@host.couch)

      click_on 'Send Quouch request'

      assert_no_current_path new_subscription_path
    end

    test 'should be able to message user' do
      Chat.destroy_all

      visit couch_path(@host.couch)

      find('.couch__chat').click
      assert_current_path %r{/chats/\d*}
      assert_selector 'h3', text: @host.first_name
      assert_no_current_path new_subscription_path
    end
  end
end

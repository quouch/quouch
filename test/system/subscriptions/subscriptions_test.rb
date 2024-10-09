# frozen_string_literal: true

require 'system_test_helper'

class MapTest < ApplicationSystemTestCase
  setup do
    @user = FactoryBot.create(:user, :for_test, :with_couch)
    sign_in_as(@user)
  end

  test 'should visit new membership page' do
    visit root_url

    click_on 'Membership'

    assert_current_path new_subscription_path
  end

  test 'should visit own membership page' do
    create_user_subscription

    visit root_url

    click_on 'Membership'

    assert_current_path subscription_path(@user.subscription)
    assert_selector '.plans__list-item.current-plan', count: 1
  end

  test 'should not fail if user is not subscribed' do
    another_user = FactoryBot.create(:user, :for_test, :with_couch, :subscribed)
    visit subscription_path(another_user.subscription)
    assert_selector '.plans__list-item', count: 1
    assert_selector '.plans__list-item.current-plan', count: 0
  end

  private

  def create_user_subscription
    plan = Plan.first
    @user.subscription = Subscription.create(plan:, stripe_id: 'fake_subscription_id')
    @user.save
  end
end

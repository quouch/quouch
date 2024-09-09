# frozen_string_literal: true

require 'test_helper'

class StripeTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = FactoryBot.build(:user, :for_test, :with_couch)
  end

  test 'should create a new plan' do
    plan = Plan.create!(name: 'Monthly Fake Plan', price_cents: 1000, interval: 'month')

    assert_not_nil plan.stripe_price_id
  end

  test 'should create stripe reference' do
    @user.save

    assert_not_nil @user.stripe_id
  end

  test 'should elegantly fail when saving user' do
    # stub Stripe::Customer.create to raise an error

    Stripe::Customer.stub(:create, -> { raise Stripe::StripeError }) do
      @user.valid?

      assert_not_nil @user.errors[:stripe_id]
    end
  end
end

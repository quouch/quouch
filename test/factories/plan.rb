# frozen_string_literal: true

FactoryBot.define do
  factory :plan do
    transient do
      user { nil }
    end

    name { 'Monthly Fake Plan' }
    price_cents { 1000 }
    interval { 'month' }
    stripe_price_id { 'fake_stripe_price_id' }

    after(:build) do |booking, evaluator|
      Subscription.create!(user: evaluator.user, plan: booking, stripe_id: 'fake_subscription_id') if evaluator.user
    end
  end
end

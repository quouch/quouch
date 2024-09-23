# frozen_string_literal: true

FactoryBot.define do
  factory :booking do
    start_date { Date.today }
    end_date { Date.today + 1 }
    request { [0, 1, 2].sample }
    message { Faker::Hipster.paragraph_by_chars(characters: 60) }
    number_travellers { 1 }
    status { 0 }
    association :user, factory: %i[user with_couch skip_validation]

    after(:build) do |booking|
      couch_owner = FactoryBot.create(:user, :with_couch, :skip_validation)
      booking.couch = couch_owner.couch
    end

    trait :pending_future_fixed do
      start_date { Date.today }
      end_date { Date.today + 1 }
      flexible { false }
      status { 0 }
      booking_date { Date.yesterday }
    end

    trait :pending_future_flexible do
      start_date { nil }
      end_date { nil }
      flexible { true }
      status { 0 }
      booking_date { Date.yesterday }
    end

    trait :pending_past_flexible do
      start_date { nil }
      end_date { nil }
      flexible { true }
      status { 0 }
      booking_date { Date.today - 2.months }
    end

    trait :pending_past_fixed do
      start_date { Date.today - 2.months }
      end_date { Date.today - 1.months }
      status { 0 }
      booking_date { Date.yesterday - 2.months }
    end

    trait :confirmed do
      status { 1 }
    end

    trait :declined do
      status { 2 }
    end

    trait :pending_reconfirmation do
      status { 3 }
    end

    trait :to_be_completed do
      start_date { Date.today - 2 }
      end_date { Date.today - 1 }
      status { 1 }
    end

    trait :cancelled do
      status { -1 }
    end

    trait :expired do
      status { -2 }
    end
  end
end

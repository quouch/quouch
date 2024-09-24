# frozen_string_literal: true

FactoryBot.define do
  factory :booking do
    transient do
      couch { FactoryBot.create(:user, :with_couch, :skip_validation).couch }
    end
    booking_date { Date.today - 1 }
    start_date { Date.today }
    end_date { Date.today + 1 }
    request { [0, 1, 2].sample }
    message { Faker::Hipster.paragraph_by_chars(characters: 60) }
    number_travellers { 1 }
    status { :pending }

    association :user, factory: %i[user with_couch skip_validation]
    traits_for_enum(:status)
    traits_for_enum(:requests)

    after(:build) do |booking, evaluator|
      booking.couch = evaluator.couch
    end

    trait :pending_future_fixed do
      start_date { Date.today }
      end_date { Date.today + 1 }
      flexible { false }
      booking_date { Date.yesterday }
    end

    trait :pending_future_flexible do
      start_date { nil }
      end_date { nil }
      flexible { true }
      booking_date { Date.yesterday }
    end

    trait :pending_past_flexible do
      start_date { nil }
      end_date { nil }
      flexible { true }
      booking_date { Date.today - 2.months }
    end

    trait :pending_past_fixed do
      start_date { Date.today - 2.months }
      end_date { Date.today - 1.months }
      booking_date { Date.yesterday - 2.months }
    end

    trait :past do
      start_date { Date.today - 2 }
      end_date { Date.today - 1 }
      status { :completed }
    end

    trait :to_be_completed do
      start_date { Date.today - 2 }
      end_date { Date.today - 1 }
      status { :confirmed }
    end

    trait :cancelled do
      start_date { Date.today - 10 }
      end_date { Date.today - 9 }
      status { :cancelled }
    end
  end
end

# frozen_string_literal: true

require 'open-uri'

require_relative '../support/addresses'

FactoryBot.define do
  factory :user, class: User do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    confirmed_at { Time.now }

    date_of_birth { 25.years.ago }

    summary { Faker::Hipster.paragraph_by_chars(characters: 60) }
    offers_couch { true }
    offers_co_work { [true, false].sample }
    offers_hang_out { [true, false].sample }
    travelling { [true, false].sample }

    user_characteristics { build_list(:user_characteristic, 3) }

    after(:build) do |user|
      file = URI.parse(Faker::Avatar.image).open
      user.photo.attach(io: file, filename: 'avatar.png', content_type: 'image/png')

      random_address = ADDRESSES.sample
      user.address = random_address[:street]
      user.zipcode = random_address[:zipcode]
      user.city = random_address[:city]
      user.country = random_address[:country]
    end

    factory :random_user do
      after(:create) do |user|
        # Needed for the search to work: add a couch for the newly created user
        Couch.create!(user:)
      end
    end

    factory :test_user, class: User do
      offers_co_work { false }
      offers_hang_out { false }
      travelling { false }
    end

    factory :test_user_couch, class: User do
      offers_co_work { false }
      offers_hang_out { false }
      travelling { false }

      after(:create) do |user|
        Couch.create!(user:)
      end
    end
  end
end

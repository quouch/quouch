# frozen_string_literal: true

require 'open-uri'

require_relative '../helpers/addresses'

FactoryBot.define do
  factory :user, class: User do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    confirmed_at { Time.now }

    date_of_birth { 25.years.ago }

    summary { Faker::Hipster.paragraph_by_chars(characters: 60) }
    offers_couch { false }
    offers_co_work { true }
    offers_hang_out { [true, false].sample }
    travelling { [true, false].sample }

    user_characteristics { build_list(:user_characteristic, 3) }
    invited_by_id { User.count.positive? ? User.first!.id : nil }
    invite_code { SecureRandom.hex(3) }

    after(:build) do |user|
      file = URI.parse(Faker::Avatar.image).open
      user.photo.attach(io: file, filename: 'avatar.png', content_type: 'image/png')

      random_address = ADDRESSES.sample
      user.address = AddressHelper::Formatter.format_address(random_address)
      user.zipcode = random_address[:zipcode]
      user.city = random_address[:city]
      user.country_code = random_address[:country_code]
    end

    trait :skip_validation do
      to_create do |instance|
        instance.save(validate: false)
      end
    end

    trait :with_couch do
      after(:create) do |user|
        # Needed for the search to work: add a couch for the newly created user
        Couch.create!(user:, capacity: 1)
      end
    end

    trait :offers_couch do
      offers_couch { true }

      after(:create) do |user|
        # Needed for the search to work: add a couch for the newly created user
        Couch.create!(user:, capacity: 1)

        # Add facilities to the couch
        user.couch.couch_facilities.create!(facility: Facility.first)
      end
    end

    trait :for_test do
      offers_co_work { true }
      offers_hang_out { false }
      travelling { false }
    end
  end
end

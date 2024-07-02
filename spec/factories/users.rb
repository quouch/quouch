FactoryBot.define do
  factory :random_user, class: User do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    confirmed_at { Time.now }

    date_of_birth { 25.years.ago }
    address { Faker::Address.street_address }
    zipcode { Faker::Address.zip_code }
    city { Faker::Address.city }
    country { Faker::Address.country }
    summary { Faker::Lorem.paragraph }
    offers_couch { [true, false].sample }
    offers_co_work { [true, false].sample }
    offers_hang_out { [true, false].sample }
    travelling { [true, false].sample }

    user_characteristics { build_list(:user_characteristic, 3) }

    after(:build) do |user|
      file = URI.open(Faker::Avatar.image)
      user.photo.attach(io: file, filename: 'avatar.png', content_type: 'image/png')
    end
  end
end

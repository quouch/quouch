# # This file should contain all the record creation needed to seed the database with its default values.
# # The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
# #
# # Examples:
# #
# #   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
# #   Character.create(name: "Luke", movie: movies.first)

require 'faker'
require 'factory_bot_rails'
require 'open-uri'

locations = [['Berlin', 'Germany'], ['Paris', 'France'], ['Madrid', 'Spain'], ['Rome', 'Italy'], ['Athens', 'Greece'], ['Lisbon','Portugal'], ['London', 'United Kingdom of Great Britain and Northern Ireland'], ['Amsterdam', 'Netherlands']]

# Characteristics
puts 'destroying & seeding characteristics...'
Characteristic.destroy_all

trans_only = Characteristic.create!(name: 'Trans Only')
party_lover = Characteristic.create!(name: 'Party Lover')
bipoc_only = Characteristic.create!(name: 'BIPOC Only')
non_smoker = Characteristic.create!(name: 'Non-Smoker')
sw_friendly = Characteristic.create!(name: 'SW Friendly')
vegan = Characteristic.create!(name: 'Vegan')
gnc = Characteristic.create!(name: 'GNC')
clean_freak = Characteristic.create!(name: 'Clean Freak')
abortion_friendly = Characteristic.create!(name: 'Abortion Friendly')
drag_performer = Characteristic.create!(name: 'Drag Performer')
sober = Characteristic.create!(name: 'Sober')
queer = Characteristic.create!(name: 'Queer')
wheelchair_accessibility = Characteristic.create!(name: 'Wheelchair Accessibility')
sign_language = Characteristic.create!(name: 'Sign Language')
neuro_diverse = Characteristic.create!(name: 'Neurodiverse')
vaccinated = Characteristic.create!(name: 'Vaccinated')
alone_time = Characteristic.create!(name: 'Alone Time')
exhibitions = Characteristic.create!(name: 'Exhibitions')
political_activism = Characteristic.create!(name: 'Political Activisim')

puts "#{Characteristic.count} characteristics created!"

# Users

puts 'destroying & seeding users...'
User.destroy_all

location = locations.sample
user1 = User.new(
  email: Faker::Internet.email,
  password: '123456',
  first_name: Faker::Games::SuperMario.character,
  last_name: Faker::TvShows::GameOfThrones.house,
  pronouns: ['she/her', 'he/him', 'they/them'].sample,
  date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 50),
  summary: Faker::Lorem.paragraph(sentence_count: 10),
  offers_couch: %i[true false].sample,
  offers_co_work: %i[true false].sample,
  offers_hang_out: %i[true false].sample,
  question_one: Faker::Lorem.paragraph(sentence_count: 10),
  question_two: Faker::Lorem.paragraph(sentence_count: 10),
  question_three: Faker::Lorem.paragraph(sentence_count: 10),
  question_four: Faker::Lorem.paragraph(sentence_count: 10),
  city: location[0],
  country: location[1],
  invite_code: 'ah67op'
)

photo1 = URI.open('https://res.cloudinary.com/dtkxl0tbk/image/upload/v1679925300/profile.jpg')
user1.photo.attach(io: photo1, filename: 'profile.jpg', content_type: 'image/jpg')
user1.save!

UserCharacteristic.create!(characteristic: queer, user_id: user1.id)
UserCharacteristic.create!(characteristic: gnc, user_id: user1.id)
UserCharacteristic.create!(characteristic: bipoc_only, user_id: user1.id)
UserCharacteristic.create!(characteristic: non_smoker, user_id: user1.id)

location = locations.sample
user2 = User.new(
  email: Faker::Internet.email,
  password: '123456',
  first_name: Faker::Games::SuperMario.character,
  last_name: Faker::TvShows::GameOfThrones.house,
  pronouns: ['she/her', 'he/him', 'they/them'].sample,
  date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 100),
  summary: Faker::Lorem.paragraph(sentence_count: 10),
  offers_couch: %i[true false].sample,
  offers_co_work: %i[true false].sample,
  offers_hang_out: %i[true false].sample,
  question_one: Faker::Lorem.paragraph(sentence_count: 10),
  question_two: Faker::Lorem.paragraph(sentence_count: 10),
  question_three: Faker::Lorem.paragraph(sentence_count: 10),
  question_four: Faker::Lorem.paragraph(sentence_count: 10),
  city: location[0],
  country: location[1],
  invite_code: 'ah67ol'
)

photo2 = URI.open('https://res.cloudinary.com/dtkxl0tbk/image/upload/v1679925300/profile.jpg')
user2.photo.attach(io: photo2, filename: 'profile.jpg', content_type: 'image/jpg')
user2.save!

UserCharacteristic.create!(characteristic: trans_only, user_id: user2.id)
UserCharacteristic.create!(characteristic: party_lover, user_id: user2.id)
UserCharacteristic.create!(characteristic: gnc, user_id: user2.id)

location = locations.sample
user3 = User.new(
  email: Faker::Internet.email,
  password: '123456',
  first_name: Faker::Games::SuperMario.character,
  last_name: Faker::TvShows::GameOfThrones.house,
  pronouns: ['she/her', 'he/him', 'they/them'].sample,
  date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 100),
  summary: Faker::Lorem.paragraph(sentence_count: 10),
  offers_couch: %i[true false].sample,
  offers_co_work: %i[true false].sample,
  offers_hang_out: %i[true false].sample,
  question_one: Faker::Lorem.paragraph(sentence_count: 10),
  question_two: Faker::Lorem.paragraph(sentence_count: 10),
  question_three: Faker::Lorem.paragraph(sentence_count: 10),
  question_four: Faker::Lorem.paragraph(sentence_count: 10),
  city: location[0],
  country: location[1],
  invite_code: 'ah68op'
)

photo3 = URI.open('https://res.cloudinary.com/dtkxl0tbk/image/upload/v1679925300/profile.jpg')
user3.photo.attach(io: photo3, filename: 'profile.jpg', content_type: 'image/jpg')
user3.save!

UserCharacteristic.create!(characteristic: neuro_diverse, user_id: user3.id)
UserCharacteristic.create!(characteristic: political_activism, user_id: user3.id)
UserCharacteristic.create!(characteristic: clean_freak, user_id: user3.id)
UserCharacteristic.create!(characteristic: trans_only, user_id: user3.id)
UserCharacteristic.create!(characteristic: bipoc_only, user_id: user3.id)

location = locations.sample
user4 = User.new(
  email: Faker::Internet.email,
  password: '123456',
  first_name: Faker::Games::SuperMario.character,
  last_name: Faker::TvShows::GameOfThrones.house,
  pronouns: ['she/her', 'he/him', 'they/them'].sample,
  date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 100),
  summary: Faker::Lorem.paragraph(sentence_count: 10),
  offers_couch: %i[true false].sample,
  offers_co_work: %i[true false].sample,
  offers_hang_out: %i[true false].sample,
  question_one: Faker::Lorem.paragraph(sentence_count: 10),
  question_two: Faker::Lorem.paragraph(sentence_count: 10),
  question_three: Faker::Lorem.paragraph(sentence_count: 10),
  question_four: Faker::Lorem.paragraph(sentence_count: 10),
  city: location[0],
  country: location[1],
  invite_code: '1h67op'
)

photo4 = URI.open('https://res.cloudinary.com/dtkxl0tbk/image/upload/v1679925300/profile.jpg')
user4.photo.attach(io: photo4, filename: 'profile.jpg', content_type: 'image/jpg')
user4.save!

UserCharacteristic.create!(characteristic: non_smoker, user_id: user4.id)
UserCharacteristic.create!(characteristic: sw_friendly, user_id: user4.id)
UserCharacteristic.create!(characteristic: vegan, user_id: user4.id)

location = locations.sample
user5 = User.new(
  email: Faker::Internet.email,
  password: '123456',
  first_name: Faker::Games::SuperMario.character,
  last_name: Faker::TvShows::GameOfThrones.house,
  pronouns: ['she/her', 'he/him', 'they/them'].sample,
  date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 100),
  summary: Faker::Lorem.paragraph(sentence_count: 10),
  offers_couch: %i[true false].sample,
  offers_co_work: %i[true false].sample,
  offers_hang_out: %i[true false].sample,
  question_one: Faker::Lorem.paragraph(sentence_count: 10),
  question_two: Faker::Lorem.paragraph(sentence_count: 10),
  question_three: Faker::Lorem.paragraph(sentence_count: 10),
  question_four: Faker::Lorem.paragraph(sentence_count: 10),
  city: location[0],
  country: location[1],
  invite_code: 'az67op'
)

photo5 = URI.open('https://res.cloudinary.com/dtkxl0tbk/image/upload/v1679925300/profile.jpg')
user5.photo.attach(io: photo5, filename: 'profile.jpg', content_type: 'image/jpg')
user5.save!

UserCharacteristic.create!(characteristic: clean_freak, user_id: user5.id)
UserCharacteristic.create!(characteristic: abortion_friendly, user_id: user5.id)
UserCharacteristic.create!(characteristic: sober, user_id: user5.id)
UserCharacteristic.create!(characteristic: exhibitions, user_id: user5.id)
UserCharacteristic.create!(characteristic: alone_time, user_id: user5.id)

location = locations.sample
user6 = User.new(
  email: Faker::Internet.email,
  password: '123456',
  first_name: Faker::Games::SuperMario.character,
  last_name: Faker::TvShows::GameOfThrones.house,
  pronouns: ['she/her', 'he/him', 'they/them'].sample,
  date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 100),
  summary: Faker::Lorem.paragraph(sentence_count: 10),
  offers_couch: %i[true false].sample,
  offers_co_work: %i[true false].sample,
  offers_hang_out: %i[true false].sample,
  question_one: Faker::Lorem.paragraph(sentence_count: 10),
  question_two: Faker::Lorem.paragraph(sentence_count: 10),
  question_three: Faker::Lorem.paragraph(sentence_count: 10),
  question_four: Faker::Lorem.paragraph(sentence_count: 10),
  city: location[0],
  country: location[1],
  invite_code: 'ah67o5'
)

photo6 = URI.open('https://res.cloudinary.com/dtkxl0tbk/image/upload/v1679925300/profile.jpg')
user6.photo.attach(io: photo6, filename: 'profile.jpg', content_type: 'image/jpg')
user6.save!

UserCharacteristic.create!(characteristic: vegan, user_id: user6.id)
UserCharacteristic.create!(characteristic: sign_language, user_id: user6.id)

location = locations.sample
user7 = User.new(
  email: Faker::Internet.email,
  password: '123456',
  first_name: Faker::Games::SuperMario.character,
  last_name: Faker::TvShows::GameOfThrones.house,
  pronouns: ['she/her', 'he/him', 'they/them'].sample,
  date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 100),
  summary: Faker::Lorem.paragraph(sentence_count: 10),
  offers_couch: %i[true false].sample,
  offers_co_work: %i[true false].sample,
  offers_hang_out: %i[true false].sample,
  question_one: Faker::Lorem.paragraph(sentence_count: 10),
  question_two: Faker::Lorem.paragraph(sentence_count: 10),
  question_three: Faker::Lorem.paragraph(sentence_count: 10),
  question_four: Faker::Lorem.paragraph(sentence_count: 10),
  city: location[0],
  country: location[1],
  invite_code: 'ah67o9'
)

photo7 = URI.open('https://res.cloudinary.com/dtkxl0tbk/image/upload/v1679925300/profile.jpg')
user7.photo.attach(io: photo7, filename: 'profile.jpg', content_type: 'image/jpg')
user7.save!

UserCharacteristic.create!(characteristic: vegan, user_id: user7.id)
UserCharacteristic.create!(characteristic: non_smoker, user_id: user7.id)
UserCharacteristic.create!(characteristic: sober, user_id: user7.id)
UserCharacteristic.create!(characteristic: queer, user_id: user7.id)

location = locations.sample
user8 = User.new(
  email: Faker::Internet.email,
  password: '123456',
  first_name: Faker::Games::SuperMario.character,
  last_name: Faker::TvShows::GameOfThrones.house,
  pronouns: ['she/her', 'he/him', 'they/them'].sample,
  date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 100),
  summary: Faker::Lorem.paragraph(sentence_count: 10),
  offers_couch: %i[true false].sample,
  offers_co_work: %i[true false].sample,
  offers_hang_out: %i[true false].sample,
  question_one: Faker::Lorem.paragraph(sentence_count: 10),
  question_two: Faker::Lorem.paragraph(sentence_count: 10),
  question_three: Faker::Lorem.paragraph(sentence_count: 10),
  question_four: Faker::Lorem.paragraph(sentence_count: 10),
  city: location[0],
  country: location[1],
  invite_code: 'ah67oy'
)

photo8 = URI.open('https://res.cloudinary.com/dtkxl0tbk/image/upload/v1679925300/profile.jpg')
user8.photo.attach(io: photo8, filename: 'profile.jpg', content_type: 'image/jpg')
user8.save!

UserCharacteristic.create!(characteristic: drag_performer, user_id: user8.id)
UserCharacteristic.create!(characteristic: sober, user_id: user8.id)
UserCharacteristic.create!(characteristic: queer, user_id: user8.id)
UserCharacteristic.create!(characteristic: wheelchair_accessibility, user_id: user8.id)
UserCharacteristic.create!(characteristic: sign_language, user_id: user8.id)

location = locations.sample
user9 = User.new(
  email: Faker::Internet.email,
  password: '123456',
  first_name: Faker::Games::SuperMario.character,
  last_name: Faker::TvShows::GameOfThrones.house,
  pronouns: ['she/her', 'he/him', 'they/them'].sample,
  date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 100),
  summary: Faker::Lorem.paragraph(sentence_count: 10),
  offers_couch: %i[true false].sample,
  offers_co_work: %i[true false].sample,
  offers_hang_out: %i[true false].sample,
  question_one: Faker::Lorem.paragraph(sentence_count: 10),
  question_two: Faker::Lorem.paragraph(sentence_count: 10),
  question_three: Faker::Lorem.paragraph(sentence_count: 10),
  question_four: Faker::Lorem.paragraph(sentence_count: 10),
  city: location[0],
  country: location[1],
  invite_code: 'ah77op'
)

photo9 = URI.open('https://res.cloudinary.com/dtkxl0tbk/image/upload/v1679925300/profile.jpg')
user9.photo.attach(io: photo9, filename: 'profile.jpg', content_type: 'image/jpg')
user9.save!

UserCharacteristic.create!(characteristic: non_smoker, user_id: user9.id)
UserCharacteristic.create!(characteristic: exhibitions, user_id: user9.id)
UserCharacteristic.create!(characteristic: bipoc_only, user_id: user9.id)
UserCharacteristic.create!(characteristic: clean_freak, user_id: user9.id)

location = locations.sample
user10 = User.new(
  email: Faker::Internet.email,
  password: '123456',
  first_name: Faker::Games::SuperMario.character,
  last_name: Faker::TvShows::GameOfThrones.house,
  pronouns: ['she/her', 'he/him', 'they/them'].sample,
  date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 100),
  summary: Faker::Lorem.paragraph(sentence_count: 10),
  offers_couch: %i[true false].sample,
  offers_co_work: %i[true false].sample,
  offers_hang_out: %i[true false].sample,
  question_one: Faker::Lorem.paragraph(sentence_count: 10),
  question_two: Faker::Lorem.paragraph(sentence_count: 10),
  question_three: Faker::Lorem.paragraph(sentence_count: 10),
  question_four: Faker::Lorem.paragraph(sentence_count: 10),
  city: location[0],
  country: location[1],
  invite_code: 'ah689p'
)

photo10 = URI.open('https://res.cloudinary.com/dtkxl0tbk/image/upload/v1679925300/profile.jpg')
user10.photo.attach(io: photo10, filename: 'profile.jpg', content_type: 'image/jpg')
user10.save!

UserCharacteristic.create!(characteristic: party_lover, user_id: user10.id)
UserCharacteristic.create!(characteristic: neuro_diverse, user_id: user10.id)
UserCharacteristic.create!(characteristic: gnc, user_id: user10.id)
UserCharacteristic.create!(characteristic: political_activism, user_id: user10.id)

location = locations.sample
user11 = User.new(
  email: Faker::Internet.email,
  password: '123456',
  first_name: Faker::Games::SuperMario.character,
  last_name: Faker::TvShows::GameOfThrones.house,
  pronouns: ['she/her', 'he/him', 'they/them'].sample,
  date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 100),
  summary: Faker::Lorem.paragraph(sentence_count: 10),
  offers_couch: %i[true false].sample,
  offers_co_work: %i[true false].sample,
  offers_hang_out: %i[true false].sample,
  question_one: Faker::Lorem.paragraph(sentence_count: 10),
  question_two: Faker::Lorem.paragraph(sentence_count: 10),
  question_three: Faker::Lorem.paragraph(sentence_count: 10),
  question_four: Faker::Lorem.paragraph(sentence_count: 10),
  city: location[0],
  country: location[1],
  invite_code: 'abz7op'
)

photo11 = URI.open('https://res.cloudinary.com/dtkxl0tbk/image/upload/v1679925300/profile.jpg')
user11.photo.attach(io: photo11, filename: 'profile.jpg', content_type: 'image/jpg')
user11.save!

UserCharacteristic.create!(characteristic: clean_freak, user_id: user11.id)
UserCharacteristic.create!(characteristic: queer, user_id: user11.id)
UserCharacteristic.create!(characteristic: alone_time, user_id: user11.id)
UserCharacteristic.create!(characteristic: bipoc_only, user_id: user11.id)
UserCharacteristic.create!(characteristic: non_smoker, user_id: user11.id)

location = locations.sample
user12 = User.new(
  email: Faker::Internet.email,
  password: '123456',
  first_name: Faker::Games::SuperMario.character,
  last_name: Faker::TvShows::GameOfThrones.house,
  pronouns: ['she/her', 'he/him', 'they/them'].sample,
  date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 100),
  summary: Faker::Lorem.paragraph(sentence_count: 10),
  offers_couch: %i[true false].sample,
  offers_co_work: %i[true false].sample,
  offers_hang_out: %i[true false].sample,
  question_one: Faker::Lorem.paragraph(sentence_count: 10),
  question_two: Faker::Lorem.paragraph(sentence_count: 10),
  question_three: Faker::Lorem.paragraph(sentence_count: 10),
  question_four: Faker::Lorem.paragraph(sentence_count: 10),
  city: location[0],
  country: location[1],
  invite_code: 'ah62op'
)

photo12 = URI.open('https://res.cloudinary.com/dtkxl0tbk/image/upload/v1679925300/profile.jpg')
user12.photo.attach(io: photo12, filename: 'profile.jpg', content_type: 'image/jpg')
user12.save!

UserCharacteristic.create!(characteristic: sw_friendly, user_id: user12.id)
UserCharacteristic.create!(characteristic: vegan, user_id: user12.id)
UserCharacteristic.create!(characteristic: alone_time, user_id: user12.id)

location = locations.sample
user13 = User.new(
  email: Faker::Internet.email,
  password: '123456',
  first_name: Faker::Games::SuperMario.character,
  last_name: Faker::TvShows::GameOfThrones.house,
  pronouns: ['she/her', 'he/him', 'they/them'].sample,
  date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 100),
  summary: Faker::Lorem.paragraph(sentence_count: 10),
  offers_couch: %i[true false].sample,
  offers_co_work: %i[true false].sample,
  offers_hang_out: %i[true false].sample,
  question_one: Faker::Lorem.paragraph(sentence_count: 10),
  question_two: Faker::Lorem.paragraph(sentence_count: 10),
  question_three: Faker::Lorem.paragraph(sentence_count: 10),
  question_four: Faker::Lorem.paragraph(sentence_count: 10),
  city: location[0],
  country: location[1],
  invite_code: 'ar67op'
)

photo13 = URI.open('https://res.cloudinary.com/dtkxl0tbk/image/upload/v1679925300/profile.jpg')
user13.photo.attach(io: photo13, filename: 'profile.jpg', content_type: 'image/jpg')
user13.save!

UserCharacteristic.create!(characteristic: trans_only, user_id: user13.id)
UserCharacteristic.create!(characteristic: party_lover, user_id: user13.id)
UserCharacteristic.create!(characteristic: political_activism, user_id: user13.id)
UserCharacteristic.create!(characteristic: sober, user_id: user13.id)

location = locations.sample
user14 = User.new(
  email: Faker::Internet.email,
  password: '123456',
  first_name: Faker::Games::SuperMario.character,
  last_name: Faker::TvShows::GameOfThrones.house,
  pronouns: ['she/her', 'he/him', 'they/them'].sample,
  date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 100),
  summary: Faker::Lorem.paragraph(sentence_count: 10),
  offers_couch: %i[true false].sample,
  offers_co_work: %i[true false].sample,
  offers_hang_out: %i[true false].sample,
  question_one: Faker::Lorem.paragraph(sentence_count: 10),
  question_two: Faker::Lorem.paragraph(sentence_count: 10),
  question_three: Faker::Lorem.paragraph(sentence_count: 10),
  question_four: Faker::Lorem.paragraph(sentence_count: 10),
  city: location[0],
  country: location[1],
  invite_code: 'bh67op'
)

photo14 = URI.open('https://res.cloudinary.com/dtkxl0tbk/image/upload/v1679925300/profile.jpg')
user14.photo.attach(io: photo14, filename: 'profile.jpg', content_type: 'image/jpg')
user14.save!

UserCharacteristic.create!(characteristic: non_smoker, user_id: user14.id)
UserCharacteristic.create!(characteristic: clean_freak, user_id: user14.id)
UserCharacteristic.create!(characteristic: drag_performer, user_id: user14.id)
UserCharacteristic.create!(characteristic: queer, user_id: user14.id)

location = locations.sample
user15 = User.new(
  email: Faker::Internet.email,
  password: '123456',
  first_name: Faker::Games::SuperMario.character,
  last_name: Faker::TvShows::GameOfThrones.house,
  pronouns: ['she/her', 'he/him', 'they/them'].sample,
  date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 100),
  summary: Faker::Lorem.paragraph(sentence_count: 10),
  offers_couch: %i[true false].sample,
  offers_co_work: %i[true false].sample,
  offers_hang_out: %i[true false].sample,
  question_one: Faker::Lorem.paragraph(sentence_count: 10),
  question_two: Faker::Lorem.paragraph(sentence_count: 10),
  question_three: Faker::Lorem.paragraph(sentence_count: 10),
  question_four: Faker::Lorem.paragraph(sentence_count: 10),
  city: location[0],
  country: location[1],
  invite_code: 'ah67wp'
)

photo15 = URI.open('https://res.cloudinary.com/dtkxl0tbk/image/upload/v1679925300/profile.jpg')
user15.photo.attach(io: photo15, filename: 'profile.jpg', content_type: 'image/jpg')
user15.save!

UserCharacteristic.create!(characteristic: exhibitions, user_id: user15.id)
UserCharacteristic.create!(characteristic: wheelchair_accessibility, user_id: user15.id)
UserCharacteristic.create!(characteristic: sign_language, user_id: user15.id)

location = locations.sample
user16 = User.new(
  email: Faker::Internet.email,
  password: '123456',
  first_name: Faker::Games::SuperMario.character,
  last_name: Faker::TvShows::GameOfThrones.house,
  pronouns: ['she/her', 'he/him', 'they/them'].sample,
  date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 100),
  summary: Faker::Lorem.paragraph(sentence_count: 10),
  offers_couch: %i[true false].sample,
  offers_co_work: %i[true false].sample,
  offers_hang_out: %i[true false].sample,
  question_one: Faker::Lorem.paragraph(sentence_count: 10),
  question_two: Faker::Lorem.paragraph(sentence_count: 10),
  question_three: Faker::Lorem.paragraph(sentence_count: 10),
  question_four: Faker::Lorem.paragraph(sentence_count: 10),
  city: location[0],
  country: location[1],
  invite_code: 'ah34op'
)

photo16 = URI.open('https://res.cloudinary.com/dtkxl0tbk/image/upload/v1679925300/profile.jpg')
user16.photo.attach(io: photo16, filename: 'profile.jpg', content_type: 'image/jpg')
user16.save!

UserCharacteristic.create!(characteristic: queer, user_id: user16.id)
UserCharacteristic.create!(characteristic: trans_only, user_id: user16.id)
UserCharacteristic.create!(characteristic: bipoc_only, user_id: user16.id)
UserCharacteristic.create!(characteristic: abortion_friendly, user_id: user16.id)
UserCharacteristic.create!(characteristic: drag_performer, user_id: user16.id)

location = locations.sample
user17 = User.new(
  email: Faker::Internet.email,
  password: '123456',
  first_name: Faker::Games::SuperMario.character,
  last_name: Faker::TvShows::GameOfThrones.house,
  pronouns: ['she/her', 'he/him', 'they/them'].sample,
  date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 100),
  summary: Faker::Lorem.paragraph(sentence_count: 10),
  offers_couch: %i[true false].sample,
  offers_co_work: %i[true false].sample,
  offers_hang_out: %i[true false].sample,
  question_one: Faker::Lorem.paragraph(sentence_count: 10),
  question_two: Faker::Lorem.paragraph(sentence_count: 10),
  question_three: Faker::Lorem.paragraph(sentence_count: 10),
  question_four: Faker::Lorem.paragraph(sentence_count: 10),
  city: location[0],
  country: location[1],
  invite_code: 'ah12op'
)

photo17 = URI.open('https://res.cloudinary.com/dtkxl0tbk/image/upload/v1679925300/profile.jpg')
user17.photo.attach(io: photo17, filename: 'profile.jpg', content_type: 'image/jpg')
user17.save!

UserCharacteristic.create!(characteristic: sober, user_id: user17.id)
UserCharacteristic.create!(characteristic: queer, user_id: user17.id)

location = locations.sample
user18 = User.new(
  email: Faker::Internet.email,
  password: '123456',
  first_name: Faker::Games::SuperMario.character,
  last_name: Faker::TvShows::GameOfThrones.house,
  pronouns: ['she/her', 'he/him', 'they/them'].sample,
  date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 100),
  summary: Faker::Lorem.paragraph(sentence_count: 10),
  offers_couch: %i[true false].sample,
  offers_co_work: %i[true false].sample,
  offers_hang_out: %i[true false].sample,
  question_one: Faker::Lorem.paragraph(sentence_count: 10),
  question_two: Faker::Lorem.paragraph(sentence_count: 10),
  question_three: Faker::Lorem.paragraph(sentence_count: 10),
  question_four: Faker::Lorem.paragraph(sentence_count: 10),
  city: location[0],
  country: location[1],
  invite_code: 'an67op'
)

photo18 = URI.open('https://res.cloudinary.com/dtkxl0tbk/image/upload/v1679925300/profile.jpg')
user18.photo.attach(io: photo18, filename: 'profile.jpg', content_type: 'image/jpg')
user18.save!

UserCharacteristic.create!(characteristic: non_smoker, user_id: user18.id)
UserCharacteristic.create!(characteristic: neuro_diverse, user_id: user18.id)
UserCharacteristic.create!(characteristic: wheelchair_accessibility, user_id: user18.id)

location = locations.sample
user19 = User.new(
  email: Faker::Internet.email,
  password: '123456',
  first_name: Faker::Games::SuperMario.character,
  last_name: Faker::TvShows::GameOfThrones.house,
  pronouns: ['she/her', 'he/him', 'they/them'].sample,
  date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 100),
  summary: Faker::Lorem.paragraph(sentence_count: 10),
  offers_couch: %i[true false].sample,
  offers_co_work: %i[true false].sample,
  offers_hang_out: %i[true false].sample,
  question_one: Faker::Lorem.paragraph(sentence_count: 10),
  question_two: Faker::Lorem.paragraph(sentence_count: 10),
  question_three: Faker::Lorem.paragraph(sentence_count: 10),
  question_four: Faker::Lorem.paragraph(sentence_count: 10),
  city: location[0],
  country: location[1],
  invite_code: 'lq67op'
)

photo19 = URI.open('https://res.cloudinary.com/dtkxl0tbk/image/upload/v1679925300/profile.jpg')
user19.photo.attach(io: photo19, filename: 'profile.jpg', content_type: 'image/jpg')
user19.save!

UserCharacteristic.create!(characteristic: trans_only, user_id: user19.id)
UserCharacteristic.create!(characteristic: party_lover, user_id: user19.id)
UserCharacteristic.create!(characteristic: bipoc_only, user_id: user19.id)
UserCharacteristic.create!(characteristic: non_smoker, user_id: user19.id)
UserCharacteristic.create!(characteristic: sw_friendly, user_id: user19.id)
UserCharacteristic.create!(characteristic: vegan, user_id: user19.id)
UserCharacteristic.create!(characteristic: gnc, user_id: user19.id)
UserCharacteristic.create!(characteristic: clean_freak, user_id: user19.id)

location = locations.sample
user20 = User.new(
  email: Faker::Internet.email,
  password: '123456',
  first_name: Faker::Games::SuperMario.character,
  last_name: Faker::TvShows::GameOfThrones.house,
  pronouns: ['she/her', 'he/him', 'they/them'].sample,
  date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 100),
  summary: Faker::Lorem.paragraph(sentence_count: 10),
  offers_couch: %i[true false].sample,
  offers_co_work: %i[true false].sample,
  offers_hang_out: %i[true false].sample,
  question_one: Faker::Lorem.paragraph(sentence_count: 10),
  question_two: Faker::Lorem.paragraph(sentence_count: 10),
  question_three: Faker::Lorem.paragraph(sentence_count: 10),
  question_four: Faker::Lorem.paragraph(sentence_count: 10),
  city: location[0],
  country: location[1],
  invite_code: 'ah623p'
)

photo20 = URI.open('https://res.cloudinary.com/dtkxl0tbk/image/upload/v1679925300/profile.jpg')
user20.photo.attach(io: photo20, filename: 'profile.jpg', content_type: 'image/jpg')
user20.save!

UserCharacteristic.create!(characteristic: abortion_friendly, user_id: user20.id)
UserCharacteristic.create!(characteristic: clean_freak, user_id: user20.id)
UserCharacteristic.create!(characteristic: sober, user_id: user20.id)
UserCharacteristic.create!(characteristic: queer, user_id: user20.id)
UserCharacteristic.create!(characteristic: sw_friendly, user_id: user20.id)
UserCharacteristic.create!(characteristic: vaccinated, user_id: user20.id)
UserCharacteristic.create!(characteristic: bipoc_only, user_id: user20.id)

puts "#{User.count} users created!"

# Couches

puts 'destroying & seeding couches...'
Couch.destroy_all

couch1 = Couch.create!(
  capacity: rand(1..6),
  user: user1
)

couch2 = Couch.create!(
  capacity: rand(1..6),
  user: user2
)

couch3 = Couch.create!(
  capacity: rand(1..6),
  user: user3
)

couch4 = Couch.create!(
  capacity: rand(1..6),
  user: user4
)

couch5 = Couch.create!(
  capacity: rand(1..6),
  user: user5
)

couch6 = Couch.create!(
  capacity: rand(1..6),
  user: user6
)

couch7 = Couch.create!(
  capacity: rand(1..6),
  user: user7
)

couch8 = Couch.create!(
  capacity: rand(1..6),
  user: user8
)

couch9 = Couch.create!(
  capacity: rand(1..6),
  user: user9
)

couch10 = Couch.create!(
  capacity: rand(1..6),
  user: user10
)

couch11 = Couch.create!(
  capacity: rand(1..6),
  user: user11
)

couch12 = Couch.create!(
  capacity: rand(1..6),
  user: user12
)

couch13 = Couch.create!(
  capacity: rand(1..6),
  user: user13
)

couch14 = Couch.create!(
  capacity: rand(1..6),
  user: user14
)

couch15 = Couch.create!(
  capacity: rand(1..6),
  user: user15
)

couch16 = Couch.create!(
  capacity: rand(1..6),
  user: user16
)

couch17 = Couch.create!(
  capacity: rand(1..6),
  user: user17
)

couch18 = Couch.create!(
  capacity: rand(1..6),
  user: user18
)

couch19 = Couch.create!(
  capacity: rand(1..6),
  user: user19
)

couch20 = Couch.create!(
  capacity: rand(1..6),
  user: user20
)

puts "#{Couch.count} couches created!"

# Facilities

puts 'destroying & seeding facilities...'
Facility.destroy_all

couch = Facility.create(name: 'couch')
file1 = File.open('app/assets/images/icons/couch.svg')
couch.svg.attach(io: file1, filename: 'couch.svg', content_type: 'image/svg')
couch.save!

bed = Facility.create(name: 'bed')
file2 = File.open('app/assets/images/icons/bed.svg')
bed.svg.attach(io: file2, filename: 'bed.svg', content_type: 'image/svg')
bed.save!

extra_key = Facility.create(name: 'extra key')
file3 = File.open('app/assets/images/icons/key.svg')
extra_key.svg.attach(io: file3, filename: 'key.svg', content_type: 'image/svg')
extra_key.save!

plant_lover = Facility.create(name: 'plant lover')
file4 = File.open('app/assets/images/icons/plant.svg')
plant_lover.svg.attach(io: file4, filename: 'plant.svg', content_type: 'image/svg')
plant_lover.save!

wifi = Facility.create(name: 'wifi')
file5 = File.open('app/assets/images/icons/wifi.svg')
wifi.svg.attach(io: file5, filename: 'wifi.svg', content_type: 'image/svg')
wifi.save!

pets_allowed = Facility.create(name: 'pets allowed')
file6 = File.open('app/assets/images/icons/pets.svg')
pets_allowed.svg.attach(io: file6, filename: 'pets.svg', content_type: 'image/svg')
pets_allowed.save!

shared_room = Facility.create(name: 'shared room')
file7 = File.open('app/assets/images/icons/shared.svg')
shared_room.svg.attach(io: file7, filename: 'shared-room.svg', content_type: 'image/svg')
shared_room.save!

balcony = Facility.create(name: 'balcony')
file8 = File.open('app/assets/images/icons/balcony.svg')
balcony.svg.attach(io: file8, filename: 'balcony.svg', content_type: 'image/svg')
balcony.save!

barrier_free = Facility.create(name: 'barrier free')
file9 = File.open('app/assets/images/icons/barrier-free.svg')
barrier_free.svg.attach(io: file9, filename: 'barrier-free.svg', content_type: 'image/svg')
barrier_free.save!

elevator = Facility.create(name: 'elevator')
file10 = File.open('app/assets/images/icons/elevator.svg')
elevator.svg.attach(io: file10, filename: 'elevator.svg', content_type: 'image/svg')
elevator.save!

private_room = Facility.create(name: 'private room')
file11 = File.open('app/assets/images/icons/lock.svg')
private_room.svg.attach(io: file11, filename: 'lock.svg', content_type: 'image/svg')
private_room.save!

vegan = Facility.create(name: 'vegan')
file12 = File.open('app/assets/images/icons/vegan.svg')
vegan.svg.attach(io: file12, filename: 'vegan.svg', content_type: 'image/svg')
vegan.save!

smoking_allowed = Facility.create(name: 'smoking allowed')
file13 = File.open('app/assets/images/icons/smoking.svg')
smoking_allowed.svg.attach(io: file13, filename: 'smoking.svg', content_type: 'image/svg')
smoking_allowed.save!

puts "#{Facility.count} facilities created!"

facilities = [couch, bed, shared_room, vegan, wifi, pets_allowed, elevator, balcony, barrier_free, plant_lover, private_room, smoking_allowed, extra_key]

# Couch_Facilities (random amount)

puts "Assigning a random amount of facilities to couch..."
CouchFacility.destroy_all

Couch.all.each do |sofa|
  facilities_array = []
  rand(1..10).times do
    facilities_array << facilities.sample
  end
  facilities_array.uniq.each { |amenity| CouchFacility.create(couch: sofa, facility: amenity) }
end

puts "#{CouchFacility.count} couch_facilities created!"
puts "done with seeding, love - you are doing an amazing job!"

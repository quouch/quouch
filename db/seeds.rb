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

# Countries

puts 'destroying & seeding countries...'
Country.destroy_all

germany = Country.create!(name: 'Germany')
france = Country.create!(name: 'France')
spain = Country.create!(name: 'Spain')
italy = Country.create!(name: 'Italy')
greece = Country.create!(name: 'Greece')
portugal = Country.create!(name: 'Portugal')
uk = Country.create!(name: 'United Kingdom')
netherlands = Country.create!(name: 'Netherlands')

puts "#{Country.count} countries created!"

# Cities

puts 'destroying & seeding cities...'
City.destroy_all

berlin = City.create!(name: 'Berlin', country: germany)
paris = City.create!(name: 'Paris', country: france)
madrid = City.create!(name: 'Madrid', country: spain)
rome = City.create!(name: 'Rome', country: italy)
athens = City.create!(name: 'Athens', country: greece)
lisbon = City.create!(name: 'Lisbon', country: portugal)
london = City.create!(name: 'London', country: uk)
amsterdam = City.create!(name: 'Amsterdam', country: netherlands)

puts "#{City.count} cities created!"

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

user1 = User.new(
  email: Faker::Internet.email,
  password: '123456',
  first_name: Faker::Games::SuperMario.character,
  last_name: Faker::TvShows::GameOfThrones.house,
  pronouns: ['she/her', 'he/him', 'they/them'].sample,
  date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 50),
  summary: Faker::Lorem.paragraph(sentence_count: 10),
  offers_couch: ['true', 'false'].sample,
  offers_co_work: ['true', 'false'].sample,
  offers_hang_out: ['true', 'false'].sample,
  question_one: Faker::Lorem.paragraph(sentence_count: 10),
  question_two: Faker::Lorem.paragraph(sentence_count: 10),
  question_three: Faker::Lorem.paragraph(sentence_count: 10),
  question_four: Faker::Lorem.paragraph(sentence_count: 10),
  city_id: [berlin.id, paris.id, madrid.id, rome.id, athens.id, lisbon.id, london.id, amsterdam.id].sample,
  country_id: [germany.id, france.id, spain.id, italy.id, greece.id, portugal.id, uk.id, netherlands.id].sample
)

user1.country = City.find(user1.city_id).country
photo1 = URI.open('https://res.cloudinary.com/dtkxl0tbk/image/upload/v1679925300/profile.jpg')
user1.photo.attach(io: photo1, filename: 'profile.jpg', content_type: 'image/jpg')
user1.save!

UserCharacteristic.create!(characteristic_id: 12, user_id: user1.id)
UserCharacteristic.create!(characteristic_id: 7, user_id: user1.id)
UserCharacteristic.create!(characteristic_id: 3, user_id: user1.id)
UserCharacteristic.create!(characteristic_id: 4, user_id: user1.id)

user2 = User.new(
  email: Faker::Internet.email,
  password: '123456',
  first_name: Faker::Games::SuperMario.character,
  last_name: Faker::TvShows::GameOfThrones.house,
  pronouns: ['she/her', 'he/him', 'they/them'].sample,
  date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 100),
  summary: Faker::Lorem.paragraph(sentence_count: 10),
  offers_couch: ['true', 'false'].sample,
  offers_co_work: ['true', 'false'].sample,
  offers_hang_out: ['true', 'false'].sample,
  question_one: Faker::Lorem.paragraph(sentence_count: 10),
  question_two: Faker::Lorem.paragraph(sentence_count: 10),
  question_three: Faker::Lorem.paragraph(sentence_count: 10),
  question_four: Faker::Lorem.paragraph(sentence_count: 10),
  city_id: [berlin.id, paris.id, madrid.id, rome.id, athens.id, lisbon.id, london.id, amsterdam.id].sample,
  country_id: [germany.id, france.id, spain.id, italy.id, greece.id, portugal.id, uk.id, netherlands.id].sample
)

user2.country = City.find(user2.city_id).country
photo2 = URI.open('https://res.cloudinary.com/dtkxl0tbk/image/upload/v1679925300/profile.jpg')
user2.photo.attach(io: photo2, filename: 'profile.jpg', content_type: 'image/jpg')
user2.save!

UserCharacteristic.create!(characteristic_id: 1, user_id: user2.id)
UserCharacteristic.create!(characteristic_id: 2, user_id: user2.id)
UserCharacteristic.create!(characteristic_id: 7, user_id: user2.id)

user3 = User.new(
  email: Faker::Internet.email,
  password: '123456',
  first_name: Faker::Games::SuperMario.character,
  last_name: Faker::TvShows::GameOfThrones.house,
  pronouns: ['she/her', 'he/him', 'they/them'].sample,
  date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 100),
  summary: Faker::Lorem.paragraph(sentence_count: 10),
  offers_couch: ['true', 'false'].sample,
  offers_co_work: ['true', 'false'].sample,
  offers_hang_out: ['true', 'false'].sample,
  question_one: Faker::Lorem.paragraph(sentence_count: 10),
  question_two: Faker::Lorem.paragraph(sentence_count: 10),
  question_three: Faker::Lorem.paragraph(sentence_count: 10),
  question_four: Faker::Lorem.paragraph(sentence_count: 10),
  city_id: [berlin.id, paris.id, madrid.id, rome.id, athens.id, lisbon.id, london.id, amsterdam.id].sample,
  country_id: [germany.id, france.id, spain.id, italy.id, greece.id, portugal.id, uk.id, netherlands.id].sample
)

user3.country = City.find(user3.city_id).country
photo3 = URI.open('https://res.cloudinary.com/dtkxl0tbk/image/upload/v1679925300/profile.jpg')
user3.photo.attach(io: photo3, filename: 'profile.jpg', content_type: 'image/jpg')
user3.save!

UserCharacteristic.create!(characteristic_id: 15, user_id: user3.id)
UserCharacteristic.create!(characteristic_id: 19, user_id: user3.id)
UserCharacteristic.create!(characteristic_id: 8, user_id: user3.id)
UserCharacteristic.create!(characteristic_id: 1, user_id: user3.id)
UserCharacteristic.create!(characteristic_id: 3, user_id: user3.id)

user4 = User.new(
  email: Faker::Internet.email,
  password: '123456',
  first_name: Faker::Games::SuperMario.character,
  last_name: Faker::TvShows::GameOfThrones.house,
  pronouns: ['she/her', 'he/him', 'they/them'].sample,
  date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 100),
  summary: Faker::Lorem.paragraph(sentence_count: 10),
  offers_couch: ['true', 'false'].sample,
  offers_co_work: ['true', 'false'].sample,
  offers_hang_out: ['true', 'false'].sample,
  question_one: Faker::Lorem.paragraph(sentence_count: 10),
  question_two: Faker::Lorem.paragraph(sentence_count: 10),
  question_three: Faker::Lorem.paragraph(sentence_count: 10),
  question_four: Faker::Lorem.paragraph(sentence_count: 10),
  city_id: [berlin.id, paris.id, madrid.id, rome.id, athens.id, lisbon.id, london.id, amsterdam.id].sample,
  country_id: [germany.id, france.id, spain.id, italy.id, greece.id, portugal.id, uk.id, netherlands.id].sample
)

user4.country = City.find(user4.city_id).country
photo4 = URI.open('https://res.cloudinary.com/dtkxl0tbk/image/upload/v1679925300/profile.jpg')
user4.photo.attach(io: photo4, filename: 'profile.jpg', content_type: 'image/jpg')
user4.save!

UserCharacteristic.create!(characteristic_id: 4, user_id: user4.id)
UserCharacteristic.create!(characteristic_id: 5, user_id: user4.id)
UserCharacteristic.create!(characteristic_id: 6, user_id: user4.id)

user5 = User.new(
  email: Faker::Internet.email,
  password: '123456',
  first_name: Faker::Games::SuperMario.character,
  last_name: Faker::TvShows::GameOfThrones.house,
  pronouns: ['she/her', 'he/him', 'they/them'].sample,
  date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 100),
  summary: Faker::Lorem.paragraph(sentence_count: 10),
  offers_couch: ['true', 'false'].sample,
  offers_co_work: ['true', 'false'].sample,
  offers_hang_out: ['true', 'false'].sample,
  question_one: Faker::Lorem.paragraph(sentence_count: 10),
  question_two: Faker::Lorem.paragraph(sentence_count: 10),
  question_three: Faker::Lorem.paragraph(sentence_count: 10),
  question_four: Faker::Lorem.paragraph(sentence_count: 10),
  city_id: [berlin.id, paris.id, madrid.id, rome.id, athens.id, lisbon.id, london.id, amsterdam.id].sample,
  country_id: [germany.id, france.id, spain.id, italy.id, greece.id, portugal.id, uk.id, netherlands.id].sample
)

user5.country = City.find(user5.city_id).country
photo5 = URI.open('https://res.cloudinary.com/dtkxl0tbk/image/upload/v1679925300/profile.jpg')
user5.photo.attach(io: photo5, filename: 'profile.jpg', content_type: 'image/jpg')
user5.save!

UserCharacteristic.create!(characteristic_id: 8, user_id: user5.id)
UserCharacteristic.create!(characteristic_id: 9, user_id: user5.id)
UserCharacteristic.create!(characteristic_id: 11, user_id: user5.id)
UserCharacteristic.create!(characteristic_id: 18, user_id: user5.id)
UserCharacteristic.create!(characteristic_id: 17, user_id: user5.id)

user6 = User.new(
  email: Faker::Internet.email,
  password: '123456',
  first_name: Faker::Games::SuperMario.character,
  last_name: Faker::TvShows::GameOfThrones.house,
  pronouns: ['she/her', 'he/him', 'they/them'].sample,
  date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 100),
  summary: Faker::Lorem.paragraph(sentence_count: 10),
  offers_couch: ['true', 'false'].sample,
  offers_co_work: ['true', 'false'].sample,
  offers_hang_out: ['true', 'false'].sample,
  question_one: Faker::Lorem.paragraph(sentence_count: 10),
  question_two: Faker::Lorem.paragraph(sentence_count: 10),
  question_three: Faker::Lorem.paragraph(sentence_count: 10),
  question_four: Faker::Lorem.paragraph(sentence_count: 10),
  city_id: [berlin.id, paris.id, madrid.id, rome.id, athens.id, lisbon.id, london.id, amsterdam.id].sample,
  country_id: [germany.id, france.id, spain.id, italy.id, greece.id, portugal.id, uk.id, netherlands.id].sample
)

user6.country = City.find(user6.city_id).country
photo6 = URI.open('https://res.cloudinary.com/dtkxl0tbk/image/upload/v1679925300/profile.jpg')
user6.photo.attach(io: photo6, filename: 'profile.jpg', content_type: 'image/jpg')
user6.save!

UserCharacteristic.create!(characteristic_id: 6, user_id: user6.id)
UserCharacteristic.create!(characteristic_id: 14, user_id: user6.id)

user7 = User.new(
  email: Faker::Internet.email,
  password: '123456',
  first_name: Faker::Games::SuperMario.character,
  last_name: Faker::TvShows::GameOfThrones.house,
  pronouns: ['she/her', 'he/him', 'they/them'].sample,
  date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 100),
  summary: Faker::Lorem.paragraph(sentence_count: 10),
  offers_couch: ['true', 'false'].sample,
  offers_co_work: ['true', 'false'].sample,
  offers_hang_out: ['true', 'false'].sample,
  question_one: Faker::Lorem.paragraph(sentence_count: 10),
  question_two: Faker::Lorem.paragraph(sentence_count: 10),
  question_three: Faker::Lorem.paragraph(sentence_count: 10),
  question_four: Faker::Lorem.paragraph(sentence_count: 10),
  city_id: [berlin.id, paris.id, madrid.id, rome.id, athens.id, lisbon.id, london.id, amsterdam.id].sample,
  country_id: [germany.id, france.id, spain.id, italy.id, greece.id, portugal.id, uk.id, netherlands.id].sample
)

user7.country = City.find(user7.city_id).country
photo7 = URI.open('https://res.cloudinary.com/dtkxl0tbk/image/upload/v1679925300/profile.jpg')
user7.photo.attach(io: photo7, filename: 'profile.jpg', content_type: 'image/jpg')
user7.save!

UserCharacteristic.create!(characteristic_id: 6, user_id: user7.id)
UserCharacteristic.create!(characteristic_id: 4, user_id: user7.id)
UserCharacteristic.create!(characteristic_id: 11, user_id: user7.id)
UserCharacteristic.create!(characteristic_id: 12, user_id: user7.id)

user8 = User.new(
  email: Faker::Internet.email,
  password: '123456',
  first_name: Faker::Games::SuperMario.character,
  last_name: Faker::TvShows::GameOfThrones.house,
  pronouns: ['she/her', 'he/him', 'they/them'].sample,
  date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 100),
  summary: Faker::Lorem.paragraph(sentence_count: 10),
  offers_couch: ['true', 'false'].sample,
  offers_co_work: ['true', 'false'].sample,
  offers_hang_out: ['true', 'false'].sample,
  question_one: Faker::Lorem.paragraph(sentence_count: 10),
  question_two: Faker::Lorem.paragraph(sentence_count: 10),
  question_three: Faker::Lorem.paragraph(sentence_count: 10),
  question_four: Faker::Lorem.paragraph(sentence_count: 10),
  city_id: [berlin.id, paris.id, madrid.id, rome.id, athens.id, lisbon.id, london.id, amsterdam.id].sample,
  country_id: [germany.id, france.id, spain.id, italy.id, greece.id, portugal.id, uk.id, netherlands.id].sample
)

user8.country = City.find(user8.city_id).country
photo8 = URI.open('https://res.cloudinary.com/dtkxl0tbk/image/upload/v1679925300/profile.jpg')
user8.photo.attach(io: photo8, filename: 'profile.jpg', content_type: 'image/jpg')
user8.save!

UserCharacteristic.create!(characteristic_id: 10, user_id: user8.id)
UserCharacteristic.create!(characteristic_id: 11, user_id: user8.id)
UserCharacteristic.create!(characteristic_id: 12, user_id: user8.id)
UserCharacteristic.create!(characteristic_id: 13, user_id: user8.id)
UserCharacteristic.create!(characteristic_id: 14, user_id: user8.id)

user9 = User.new(
  email: Faker::Internet.email,
  password: '123456',
  first_name: Faker::Games::SuperMario.character,
  last_name: Faker::TvShows::GameOfThrones.house,
  pronouns: ['she/her', 'he/him', 'they/them'].sample,
  date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 100),
  summary: Faker::Lorem.paragraph(sentence_count: 10),
  offers_couch: ['true', 'false'].sample,
  offers_co_work: ['true', 'false'].sample,
  offers_hang_out: ['true', 'false'].sample,
  question_one: Faker::Lorem.paragraph(sentence_count: 10),
  question_two: Faker::Lorem.paragraph(sentence_count: 10),
  question_three: Faker::Lorem.paragraph(sentence_count: 10),
  question_four: Faker::Lorem.paragraph(sentence_count: 10),
  city_id: [berlin.id, paris.id, madrid.id, rome.id, athens.id, lisbon.id, london.id, amsterdam.id].sample,
  country_id: [germany.id, france.id, spain.id, italy.id, greece.id, portugal.id, uk.id, netherlands.id].sample
)

user9.country = City.find(user9.city_id).country
photo9 = URI.open('https://res.cloudinary.com/dtkxl0tbk/image/upload/v1679925300/profile.jpg')
user9.photo.attach(io: photo9, filename: 'profile.jpg', content_type: 'image/jpg')
user9.save!

UserCharacteristic.create!(characteristic_id: 4, user_id: user9.id)
UserCharacteristic.create!(characteristic_id: 18, user_id: user9.id)
UserCharacteristic.create!(characteristic_id: 3, user_id: user9.id)
UserCharacteristic.create!(characteristic_id: 8, user_id: user9.id)

user10 = User.new(
  email: Faker::Internet.email,
  password: '123456',
  first_name: Faker::Games::SuperMario.character,
  last_name: Faker::TvShows::GameOfThrones.house,
  pronouns: ['she/her', 'he/him', 'they/them'].sample,
  date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 100),
  summary: Faker::Lorem.paragraph(sentence_count: 10),
  offers_couch: ['true', 'false'].sample,
  offers_co_work: ['true', 'false'].sample,
  offers_hang_out: ['true', 'false'].sample,
  question_one: Faker::Lorem.paragraph(sentence_count: 10),
  question_two: Faker::Lorem.paragraph(sentence_count: 10),
  question_three: Faker::Lorem.paragraph(sentence_count: 10),
  question_four: Faker::Lorem.paragraph(sentence_count: 10),
  city_id: [berlin.id, paris.id, madrid.id, rome.id, athens.id, lisbon.id, london.id, amsterdam.id].sample,
  country_id: [germany.id, france.id, spain.id, italy.id, greece.id, portugal.id, uk.id, netherlands.id].sample
)

user10.country = City.find(user10.city_id).country
photo10 = URI.open('https://res.cloudinary.com/dtkxl0tbk/image/upload/v1679925300/profile.jpg')
user10.photo.attach(io: photo10, filename: 'profile.jpg', content_type: 'image/jpg')
user10.save!

UserCharacteristic.create!(characteristic_id: 2, user_id: user10.id)
UserCharacteristic.create!(characteristic_id: 15, user_id: user10.id)
UserCharacteristic.create!(characteristic_id: 7, user_id: user10.id)
UserCharacteristic.create!(characteristic_id: 19, user_id: user10.id)

user11 = User.new(
  email: Faker::Internet.email,
  password: '123456',
  first_name: Faker::Games::SuperMario.character,
  last_name: Faker::TvShows::GameOfThrones.house,
  pronouns: ['she/her', 'he/him', 'they/them'].sample,
  date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 100),
  summary: Faker::Lorem.paragraph(sentence_count: 10),
  offers_couch: ['true', 'false'].sample,
  offers_co_work: ['true', 'false'].sample,
  offers_hang_out: ['true', 'false'].sample,
  question_one: Faker::Lorem.paragraph(sentence_count: 10),
  question_two: Faker::Lorem.paragraph(sentence_count: 10),
  question_three: Faker::Lorem.paragraph(sentence_count: 10),
  question_four: Faker::Lorem.paragraph(sentence_count: 10),
  city_id: [berlin.id, paris.id, madrid.id, rome.id, athens.id, lisbon.id, london.id, amsterdam.id].sample,
  country_id: [germany.id, france.id, spain.id, italy.id, greece.id, portugal.id, uk.id, netherlands.id].sample
)

user11.country = City.find(user11.city_id).country
photo11 = URI.open('https://res.cloudinary.com/dtkxl0tbk/image/upload/v1679925300/profile.jpg')
user11.photo.attach(io: photo11, filename: 'profile.jpg', content_type: 'image/jpg')
user11.save!

UserCharacteristic.create!(characteristic_id: 8, user_id: user11.id)
UserCharacteristic.create!(characteristic_id: 12, user_id: user11.id)
UserCharacteristic.create!(characteristic_id: 17, user_id: user11.id)
UserCharacteristic.create!(characteristic_id: 3, user_id: user11.id)
UserCharacteristic.create!(characteristic_id: 4, user_id: user11.id)

user12 = User.new(
  email: Faker::Internet.email,
  password: '123456',
  first_name: Faker::Games::SuperMario.character,
  last_name: Faker::TvShows::GameOfThrones.house,
  pronouns: ['she/her', 'he/him', 'they/them'].sample,
  date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 100),
  summary: Faker::Lorem.paragraph(sentence_count: 10),
  offers_couch: ['true', 'false'].sample,
  offers_co_work: ['true', 'false'].sample,
  offers_hang_out: ['true', 'false'].sample,
  question_one: Faker::Lorem.paragraph(sentence_count: 10),
  question_two: Faker::Lorem.paragraph(sentence_count: 10),
  question_three: Faker::Lorem.paragraph(sentence_count: 10),
  question_four: Faker::Lorem.paragraph(sentence_count: 10),
  city_id: [berlin.id, paris.id, madrid.id, rome.id, athens.id, lisbon.id, london.id, amsterdam.id].sample,
  country_id: [germany.id, france.id, spain.id, italy.id, greece.id, portugal.id, uk.id, netherlands.id].sample
)

user12.country = City.find(user12.city_id).country
photo12 = URI.open('https://res.cloudinary.com/dtkxl0tbk/image/upload/v1679925300/profile.jpg')
user12.photo.attach(io: photo12, filename: 'profile.jpg', content_type: 'image/jpg')
user12.save!

UserCharacteristic.create!(characteristic_id: 5, user_id: user12.id)
UserCharacteristic.create!(characteristic_id: 6, user_id: user12.id)
UserCharacteristic.create!(characteristic_id: 17, user_id: user12.id)

user13 = User.new(
  email: Faker::Internet.email,
  password: '123456',
  first_name: Faker::Games::SuperMario.character,
  last_name: Faker::TvShows::GameOfThrones.house,
  pronouns: ['she/her', 'he/him', 'they/them'].sample,
  date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 100),
  summary: Faker::Lorem.paragraph(sentence_count: 10),
  offers_couch: ['true', 'false'].sample,
  offers_co_work: ['true', 'false'].sample,
  offers_hang_out: ['true', 'false'].sample,
  question_one: Faker::Lorem.paragraph(sentence_count: 10),
  question_two: Faker::Lorem.paragraph(sentence_count: 10),
  question_three: Faker::Lorem.paragraph(sentence_count: 10),
  question_four: Faker::Lorem.paragraph(sentence_count: 10),
  city_id: [berlin.id, paris.id, madrid.id, rome.id, athens.id, lisbon.id, london.id, amsterdam.id].sample,
  country_id: [germany.id, france.id, spain.id, italy.id, greece.id, portugal.id, uk.id, netherlands.id].sample
)

user13.country = City.find(user13.city_id).country
photo13 = URI.open('https://res.cloudinary.com/dtkxl0tbk/image/upload/v1679925300/profile.jpg')
user13.photo.attach(io: photo13, filename: 'profile.jpg', content_type: 'image/jpg')
user13.save!

UserCharacteristic.create!(characteristic_id: 1, user_id: user13.id)
UserCharacteristic.create!(characteristic_id: 2, user_id: user13.id)
UserCharacteristic.create!(characteristic_id: 19, user_id: user13.id)
UserCharacteristic.create!(characteristic_id: 11, user_id: user13.id)

user14 = User.new(
  email: Faker::Internet.email,
  password: '123456',
  first_name: Faker::Games::SuperMario.character,
  last_name: Faker::TvShows::GameOfThrones.house,
  pronouns: ['she/her', 'he/him', 'they/them'].sample,
  date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 100),
  summary: Faker::Lorem.paragraph(sentence_count: 10),
  offers_couch: ['true', 'false'].sample,
  offers_co_work: ['true', 'false'].sample,
  offers_hang_out: ['true', 'false'].sample,
  question_one: Faker::Lorem.paragraph(sentence_count: 10),
  question_two: Faker::Lorem.paragraph(sentence_count: 10),
  question_three: Faker::Lorem.paragraph(sentence_count: 10),
  question_four: Faker::Lorem.paragraph(sentence_count: 10),
  city_id: [berlin.id, paris.id, madrid.id, rome.id, athens.id, lisbon.id, london.id, amsterdam.id].sample,
  country_id: [germany.id, france.id, spain.id, italy.id, greece.id, portugal.id, uk.id, netherlands.id].sample
)

user14.country = City.find(user14.city_id).country
photo14 = URI.open('https://res.cloudinary.com/dtkxl0tbk/image/upload/v1679925300/profile.jpg')
user14.photo.attach(io: photo14, filename: 'profile.jpg', content_type: 'image/jpg')
user14.save!

UserCharacteristic.create!(characteristic_id: 4, user_id: user14.id)
UserCharacteristic.create!(characteristic_id: 8, user_id: user14.id)
UserCharacteristic.create!(characteristic_id: 10, user_id: user14.id)
UserCharacteristic.create!(characteristic_id: 12, user_id: user14.id)

user15 = User.new(
  email: Faker::Internet.email,
  password: '123456',
  first_name: Faker::Games::SuperMario.character,
  last_name: Faker::TvShows::GameOfThrones.house,
  pronouns: ['she/her', 'he/him', 'they/them'].sample,
  date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 100),
  summary: Faker::Lorem.paragraph(sentence_count: 10),
  offers_couch: ['true', 'false'].sample,
  offers_co_work: ['true', 'false'].sample,
  offers_hang_out: ['true', 'false'].sample,
  question_one: Faker::Lorem.paragraph(sentence_count: 10),
  question_two: Faker::Lorem.paragraph(sentence_count: 10),
  question_three: Faker::Lorem.paragraph(sentence_count: 10),
  question_four: Faker::Lorem.paragraph(sentence_count: 10),
  city_id: [berlin.id, paris.id, madrid.id, rome.id, athens.id, lisbon.id, london.id, amsterdam.id].sample,
  country_id: [germany.id, france.id, spain.id, italy.id, greece.id, portugal.id, uk.id, netherlands.id].sample
)

user15.country = City.find(user15.city_id).country
photo15 = URI.open('https://res.cloudinary.com/dtkxl0tbk/image/upload/v1679925300/profile.jpg')
user15.photo.attach(io: photo15, filename: 'profile.jpg', content_type: 'image/jpg')
user15.save!

UserCharacteristic.create!(characteristic_id: 18, user_id: user15.id)
UserCharacteristic.create!(characteristic_id: 13, user_id: user15.id)
UserCharacteristic.create!(characteristic_id: 14, user_id: user15.id)

user16 = User.new(
  email: Faker::Internet.email,
  password: '123456',
  first_name: Faker::Games::SuperMario.character,
  last_name: Faker::TvShows::GameOfThrones.house,
  pronouns: ['she/her', 'he/him', 'they/them'].sample,
  date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 100),
  summary: Faker::Lorem.paragraph(sentence_count: 10),
  offers_couch: ['true', 'false'].sample,
  offers_co_work: ['true', 'false'].sample,
  offers_hang_out: ['true', 'false'].sample,
  question_one: Faker::Lorem.paragraph(sentence_count: 10),
  question_two: Faker::Lorem.paragraph(sentence_count: 10),
  question_three: Faker::Lorem.paragraph(sentence_count: 10),
  question_four: Faker::Lorem.paragraph(sentence_count: 10),
  city_id: [berlin.id, paris.id, madrid.id, rome.id, athens.id, lisbon.id, london.id, amsterdam.id].sample,
  country_id: [germany.id, france.id, spain.id, italy.id, greece.id, portugal.id, uk.id, netherlands.id].sample
)

user16.country = City.find(user16.city_id).country
photo16 = URI.open('https://res.cloudinary.com/dtkxl0tbk/image/upload/v1679925300/profile.jpg')
user16.photo.attach(io: photo16, filename: 'profile.jpg', content_type: 'image/jpg')
user16.save!

UserCharacteristic.create!(characteristic_id: 12, user_id: user16.id)
UserCharacteristic.create!(characteristic_id: 1, user_id: user16.id)
UserCharacteristic.create!(characteristic_id: 3, user_id: user16.id)
UserCharacteristic.create!(characteristic_id: 9, user_id: user16.id)
UserCharacteristic.create!(characteristic_id: 10, user_id: user16.id)

user17 = User.new(
  email: Faker::Internet.email,
  password: '123456',
  first_name: Faker::Games::SuperMario.character,
  last_name: Faker::TvShows::GameOfThrones.house,
  pronouns: ['she/her', 'he/him', 'they/them'].sample,
  date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 100),
  summary: Faker::Lorem.paragraph(sentence_count: 10),
  offers_couch: ['true', 'false'].sample,
  offers_co_work: ['true', 'false'].sample,
  offers_hang_out: ['true', 'false'].sample,
  question_one: Faker::Lorem.paragraph(sentence_count: 10),
  question_two: Faker::Lorem.paragraph(sentence_count: 10),
  question_three: Faker::Lorem.paragraph(sentence_count: 10),
  question_four: Faker::Lorem.paragraph(sentence_count: 10),
  city_id: [berlin.id, paris.id, madrid.id, rome.id, athens.id, lisbon.id, london.id, amsterdam.id].sample,
  country_id: [germany.id, france.id, spain.id, italy.id, greece.id, portugal.id, uk.id, netherlands.id].sample
)

user17.country = City.find(user17.city_id).country
photo17 = URI.open('https://res.cloudinary.com/dtkxl0tbk/image/upload/v1679925300/profile.jpg')
user17.photo.attach(io: photo17, filename: 'profile.jpg', content_type: 'image/jpg')
user17.save!

UserCharacteristic.create!(characteristic_id: 11, user_id: user17.id)
UserCharacteristic.create!(characteristic_id: 12, user_id: user17.id)

user18 = User.new(
  email: Faker::Internet.email,
  password: '123456',
  first_name: Faker::Games::SuperMario.character,
  last_name: Faker::TvShows::GameOfThrones.house,
  pronouns: ['she/her', 'he/him', 'they/them'].sample,
  date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 100),
  summary: Faker::Lorem.paragraph(sentence_count: 10),
  offers_couch: ['true', 'false'].sample,
  offers_co_work: ['true', 'false'].sample,
  offers_hang_out: ['true', 'false'].sample,
  question_one: Faker::Lorem.paragraph(sentence_count: 10),
  question_two: Faker::Lorem.paragraph(sentence_count: 10),
  question_three: Faker::Lorem.paragraph(sentence_count: 10),
  question_four: Faker::Lorem.paragraph(sentence_count: 10),
  city_id: [berlin.id, paris.id, madrid.id, rome.id, athens.id, lisbon.id, london.id, amsterdam.id].sample,
  country_id: [germany.id, france.id, spain.id, italy.id, greece.id, portugal.id, uk.id, netherlands.id].sample
)

user18.country = City.find(user18.city_id).country
photo18 = URI.open('https://res.cloudinary.com/dtkxl0tbk/image/upload/v1679925300/profile.jpg')
user18.photo.attach(io: photo18, filename: 'profile.jpg', content_type: 'image/jpg')
user18.save!

UserCharacteristic.create!(characteristic_id: 4, user_id: user18.id)
UserCharacteristic.create!(characteristic_id: 15, user_id: user18.id)
UserCharacteristic.create!(characteristic_id: 13, user_id: user18.id)

user19 = User.new(
  email: Faker::Internet.email,
  password: '123456',
  first_name: Faker::Games::SuperMario.character,
  last_name: Faker::TvShows::GameOfThrones.house,
  pronouns: ['she/her', 'he/him', 'they/them'].sample,
  date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 100),
  summary: Faker::Lorem.paragraph(sentence_count: 10),
  offers_couch: ['true', 'false'].sample,
  offers_co_work: ['true', 'false'].sample,
  offers_hang_out: ['true', 'false'].sample,
  question_one: Faker::Lorem.paragraph(sentence_count: 10),
  question_two: Faker::Lorem.paragraph(sentence_count: 10),
  question_three: Faker::Lorem.paragraph(sentence_count: 10),
  question_four: Faker::Lorem.paragraph(sentence_count: 10),
  city_id: [berlin.id, paris.id, madrid.id, rome.id, athens.id, lisbon.id, london.id, amsterdam.id].sample,
  country_id: [germany.id, france.id, spain.id, italy.id, greece.id, portugal.id, uk.id, netherlands.id].sample
)

user19.country = City.find(user19.city_id).country
photo19 = URI.open('https://res.cloudinary.com/dtkxl0tbk/image/upload/v1679925300/profile.jpg')
user19.photo.attach(io: photo19, filename: 'profile.jpg', content_type: 'image/jpg')
user19.save!

UserCharacteristic.create!(characteristic_id: 1, user_id: user19.id)
UserCharacteristic.create!(characteristic_id: 2, user_id: user19.id)
UserCharacteristic.create!(characteristic_id: 3, user_id: user19.id)
UserCharacteristic.create!(characteristic_id: 4, user_id: user19.id)
UserCharacteristic.create!(characteristic_id: 5, user_id: user19.id)
UserCharacteristic.create!(characteristic_id: 6, user_id: user19.id)
UserCharacteristic.create!(characteristic_id: 7, user_id: user19.id)
UserCharacteristic.create!(characteristic_id: 8, user_id: user19.id)

user20 = User.new(
  email: Faker::Internet.email,
  password: '123456',
  first_name: Faker::Games::SuperMario.character,
  last_name: Faker::TvShows::GameOfThrones.house,
  pronouns: ['she/her', 'he/him', 'they/them'].sample,
  date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 100),
  summary: Faker::Lorem.paragraph(sentence_count: 10),
  offers_couch: ['true', 'false'].sample,
  offers_co_work: ['true', 'false'].sample,
  offers_hang_out: ['true', 'false'].sample,
  question_one: Faker::Lorem.paragraph(sentence_count: 10),
  question_two: Faker::Lorem.paragraph(sentence_count: 10),
  question_three: Faker::Lorem.paragraph(sentence_count: 10),
  question_four: Faker::Lorem.paragraph(sentence_count: 10),
  city_id: [berlin.id, paris.id, madrid.id, rome.id, athens.id, lisbon.id, london.id, amsterdam.id].sample,
  country_id: [germany.id, france.id, spain.id, italy.id, greece.id, portugal.id, uk.id, netherlands.id].sample
)

user20.country = City.find(user20.city_id).country
photo20 = URI.open('https://res.cloudinary.com/dtkxl0tbk/image/upload/v1679925300/profile.jpg')
user20.photo.attach(io: photo20, filename: 'profile.jpg', content_type: 'image/jpg')
user20.save!

UserCharacteristic.create!(characteristic_id: 9, user_id: user20.id)
UserCharacteristic.create!(characteristic_id: 8, user_id: user20.id)
UserCharacteristic.create!(characteristic_id: 11, user_id: user20.id)
UserCharacteristic.create!(characteristic_id: 12, user_id: user20.id)
UserCharacteristic.create!(characteristic_id: 5, user_id: user20.id)
UserCharacteristic.create!(characteristic_id: 16, user_id: user20.id)
UserCharacteristic.create!(characteristic_id: 3, user_id: user20.id)

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
file1 = URI.open('https://res.cloudinary.com/dtkxl0tbk/image/upload/v1680088490/couch.svg')
couch.image.attach(io: file1, filename: 'couch.svg', content_type: 'image/svg')
couch.save!

bed = Facility.create(name: 'bed')
file2 = URI.open('https://res.cloudinary.com/dtkxl0tbk/image/upload/v1680088492/bed.svg')
bed.image.attach(io: file2, filename: 'bed.svg', content_type: 'image/svg')
bed.save!

extra_key = Facility.create(name: 'extra key')
file3 = URI.open('https://res.cloudinary.com/dtkxl0tbk/image/upload/v1680088491/extra-key.svg')
extra_key.image.attach(io: file3, filename: 'extra-key.svg', content_type: 'image/svg')
extra_key.save!

plant_lover = Facility.create(name: 'plant lover')
file4 = URI.open('https://res.cloudinary.com/dtkxl0tbk/image/upload/v1680088492/plant-lover.svg')
plant_lover.image.attach(io: file4, filename: 'plant-lover.svg', content_type: 'image/svg')
plant_lover.save!

wifi = Facility.create(name: 'wifi')
file5 = URI.open('https://res.cloudinary.com/dtkxl0tbk/image/upload/v1680088493/wifi.svg')
wifi.image.attach(io: file5, filename: 'wifi.svg', content_type: 'image/svg')
wifi.save!

pets_allowed = Facility.create(name: 'pets allowed')
file6 = URI.open('https://res.cloudinary.com/dtkxl0tbk/image/upload/v1680088492/pets-allowed.svg')
pets_allowed.image.attach(io: file6, filename: 'pets-allowed.svg', content_type: 'image/svg')
pets_allowed.save!

shared_room = Facility.create(name: 'shared room')
file7 = URI.open('https://res.cloudinary.com/dtkxl0tbk/image/upload/v1680089510/shared-room.svg')
shared_room.image.attach(io: file7, filename: 'shared-room.svg', content_type: 'image/svg')
shared_room.save!

balcony = Facility.create(name: 'balcony')
file8 = URI.open('https://res.cloudinary.com/dtkxl0tbk/image/upload/v1680088490/balcony.svg')
balcony.image.attach(io: file8, filename: 'balcony.svg', content_type: 'image/svg')
balcony.save!

barrier_free = Facility.create(name: 'barrier free')
file9 = URI.open('https://res.cloudinary.com/dtkxl0tbk/image/upload/v1680088490/barrier-free.svg')
barrier_free.image.attach(io: file9, filename: 'barrier-free.svg', content_type: 'image/svg')
barrier_free.save!

elevator = Facility.create(name: 'elevator')
file10 = URI.open('https://res.cloudinary.com/dtkxl0tbk/image/upload/v1680088491/elevator.svg')
elevator.image.attach(io: file10, filename: 'elevator.svg', content_type: 'image/svg')
elevator.save!

private_room = Facility.create(name: 'private room')
file11 = URI.open('https://res.cloudinary.com/dtkxl0tbk/image/upload/v1680088492/private-room.svg')
private_room.image.attach(io: file11, filename: 'private-room.svg', content_type: 'image/svg')
private_room.save!

vegan = Facility.create(name: 'vegan')
file12 = URI.open('https://res.cloudinary.com/dtkxl0tbk/image/upload/v1680088492/vegan.svg')
vegan.image.attach(io: file12, filename: 'vegan.svg', content_type: 'image/svg')
vegan.save!

smoking_allowed = Facility.create(name: 'smoking allowed')
file13 = URI.open('https://res.cloudinary.com/dtkxl0tbk/image/upload/v1680088493/smoking-allowed.svg')
smoking_allowed.image.attach(io: file13, filename: 'smoking-allowed.svg', content_type: 'image/svg')
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

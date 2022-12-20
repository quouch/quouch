# # This file should contain all the record creation needed to seed the database with its default values.
# # The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
# #
# # Examples:
# #
# #   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
# #   Character.create(name: "Luke", movie: movies.first)

require 'faker'
require 'factory_bot_rails'

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

# Users

puts 'destroying & seeding users...'
User.destroy_all

user1 = User.create!(
  email: Faker::Internet.email,
  password: '123456',
  encrypted_password: '123456',
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
  city_id: [berlin.id, paris.id, madrid.id, rome.id, athens.id, lisbon.id, london.id, amsterdam.id].sample
)

user2 = User.create!(
  email: Faker::Internet.email,
  password: '123456',
  encrypted_password: '123456',
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
  city_id: [berlin.id, paris.id, madrid.id, rome.id, athens.id, lisbon.id, london.id, amsterdam.id].sample
)

user3 = User.create!(
  email: Faker::Internet.email,
  password: '123456',
  encrypted_password: '123456',
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
  city_id: [berlin.id, paris.id, madrid.id, rome.id, athens.id, lisbon.id, london.id, amsterdam.id].sample
)

user4 = User.create!(
  email: Faker::Internet.email,
  password: '123456',
  encrypted_password: '123456',
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
  city_id: [berlin.id, paris.id, madrid.id, rome.id, athens.id, lisbon.id, london.id, amsterdam.id].sample
)

user5 = User.create!(
  email: Faker::Internet.email,
  password: '123456',
  encrypted_password: '123456',
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
  city_id: [berlin.id, paris.id, madrid.id, rome.id, athens.id, lisbon.id, london.id, amsterdam.id].sample
)

user6 = User.create!(
  email: Faker::Internet.email,
  password: '123456',
  encrypted_password: '123456',
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
  city_id: [berlin.id, paris.id, madrid.id, rome.id, athens.id, lisbon.id, london.id, amsterdam.id].sample
)

user7 = User.create!(
  email: Faker::Internet.email,
  password: '123456',
  encrypted_password: '123456',
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
  city_id: [berlin.id, paris.id, madrid.id, rome.id, athens.id, lisbon.id, london.id, amsterdam.id].sample
)

user8 = User.create!(
  email: Faker::Internet.email,
  password: '123456',
  encrypted_password: '123456',
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
  city_id: [berlin.id, paris.id, madrid.id, rome.id, athens.id, lisbon.id, london.id, amsterdam.id].sample
)

user9 = User.create!(
  email: Faker::Internet.email,
  password: '123456',
  encrypted_password: '123456',
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
  city_id: [berlin.id, paris.id, madrid.id, rome.id, athens.id, lisbon.id, london.id, amsterdam.id].sample
)

user10 = User.create!(
  email: Faker::Internet.email,
  password: '123456',
  encrypted_password: '123456',
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
  city_id: [berlin.id, paris.id, madrid.id, rome.id, athens.id, lisbon.id, london.id, amsterdam.id].sample
)

user11 = User.create!(
  email: Faker::Internet.email,
  password: '123456',
  encrypted_password: '123456',
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
  city_id: [berlin.id, paris.id, madrid.id, rome.id, athens.id, lisbon.id, london.id, amsterdam.id].sample
)

user12 = User.create!(
  email: Faker::Internet.email,
  password: '123456',
  encrypted_password: '123456',
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
  city_id: [berlin.id, paris.id, madrid.id, rome.id, athens.id, lisbon.id, london.id, amsterdam.id].sample
)

user13 = User.create!(
  email: Faker::Internet.email,
  password: '123456',
  encrypted_password: '123456',
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
  city_id: [berlin.id, paris.id, madrid.id, rome.id, athens.id, lisbon.id, london.id, amsterdam.id].sample
)

user14 = User.create!(
  email: Faker::Internet.email,
  password: '123456',
  encrypted_password: '123456',
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
  city_id: [berlin.id, paris.id, madrid.id, rome.id, athens.id, lisbon.id, london.id, amsterdam.id].sample
)

user15 = User.create!(
  email: Faker::Internet.email,
  password: '123456',
  encrypted_password: '123456',
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
  city_id: [berlin.id, paris.id, madrid.id, rome.id, athens.id, lisbon.id, london.id, amsterdam.id].sample
)

user16 = User.create!(
  email: Faker::Internet.email,
  password: '123456',
  encrypted_password: '123456',
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
  city_id: [berlin.id, paris.id, madrid.id, rome.id, athens.id, lisbon.id, london.id, amsterdam.id].sample
)

user17 = User.create!(
  email: Faker::Internet.email,
  password: '123456',
  encrypted_password: '123456',
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
  city_id: [berlin.id, paris.id, madrid.id, rome.id, athens.id, lisbon.id, london.id, amsterdam.id].sample
)

user18 = User.create!(
  email: Faker::Internet.email,
  password: '123456',
  encrypted_password: '123456',
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
  city_id: [berlin.id, paris.id, madrid.id, rome.id, athens.id, lisbon.id, london.id, amsterdam.id].sample
)

user19 = User.create!(
  email: Faker::Internet.email,
  password: '123456',
  encrypted_password: '123456',
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
  city_id: [berlin.id, paris.id, madrid.id, rome.id, athens.id, lisbon.id, london.id, amsterdam.id].sample
)

user20 = User.create!(
  email: Faker::Internet.email,
  password: '123456',
  encrypted_password: '123456',
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
  city_id: [berlin.id, paris.id, madrid.id, rome.id, athens.id, lisbon.id, london.id, amsterdam.id].sample
)

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
file = File.open("app/assets/images/icons/couch.svg")
couch.image.attach(io: file, filename: 'couch.svg', content_type: 'image/svg')
couch.save!

bed = Facility.create(name: 'bed')
file = File.open("app/assets/images/icons/bed.svg")
bed.image.attach(io: file, filename: 'bed.svg', content_type: 'image/svg')
bed.save!

shared_bathroom = Facility.create(name: 'shared bathroom')
file = File.open("app/assets/images/icons/bathroom.svg")
shared_bathroom.image.attach(io: file, filename: 'bathroom.svg', content_type: 'image/svg')
shared_bathroom.save!

private_bathroom = Facility.create(name: 'private bathroom')
file = File.open("app/assets/images/icons/bathroom.svg")
private_bathroom.image.attach(io: file, filename: 'bathroom.svg', content_type: 'image/svg')
private_bathroom.save!

wifi = Facility.create(name: 'wifi')
file = File.open("app/assets/images/icons/wifi.svg")
wifi.image.attach(io: file, filename: 'wifi.svg', content_type: 'image/svg')
wifi.save!

pets_allowed = Facility.create(name: 'pets allowed')
file = File.open("app/assets/images/icons/pets.svg")
pets_allowed.image.attach(io: file, filename: 'pets.svg', content_type: 'image/svg')
pets_allowed.save!

shared_kitchen = Facility.create(name: 'shared kitchen')
file = File.open("app/assets/images/icons/kitchen.svg")
shared_kitchen.image.attach(io: file, filename: 'kitchen.svg', content_type: 'image/svg')
shared_kitchen.save!

tv = Facility.create(name: 'TV')
file = File.open("app/assets/images/icons/tv.svg")
tv.image.attach(io: file, filename: 'tv.svg', content_type: 'image/svg')
tv.save!

washing_machine = Facility.create(name: 'washing machine')
file = File.open("app/assets/images/icons/laundry.svg")
washing_machine.image.attach(io: file, filename: 'laundry.svg', content_type: 'image/svg')
washing_machine.save!

public_transport = Facility.create(name: 'public transport')
file = File.open("app/assets/images/icons/public.svg")
public_transport.image.attach(io: file, filename: 'public.svg', content_type: 'image/svg')
public_transport.save!

private_room = Facility.create(name: 'private room')
file = File.open("app/assets/images/icons/private.svg")
private_room.image.attach(io: file, filename: 'private.svg', content_type: 'image/svg')
private_room.save!

supermarket = Facility.create(name: 'supermarket')
file = File.open("app/assets/images/icons/supermarket.svg")
supermarket.image.attach(io: file, filename: 'supermarket.svg', content_type: 'image/svg')
supermarket.save!

smoking_allowed = Facility.create(name: 'smoking allowed')
file = File.open("app/assets/images/icons/smoking.svg")
smoking_allowed.image.attach(io: file, filename: 'smoking.svg', content_type: 'image/svg')
smoking_allowed.save!

puts "#{Facility.count} facilities created!"

facilities = [couch, bed, shared_bathroom, private_bathroom, wifi, pets_allowed, shared_kitchen, tv, washing_machine,
              public_transport, private_room, supermarket, smoking_allowed]

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

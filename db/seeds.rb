# Characteristics
puts "destroying & seeding characteristics..."
Characteristic.destroy_all

Characteristic.create!(name: "Trans Only")
Characteristic.create!(name: "BIPOC Only")
Characteristic.create!(name: "Non-Smoker")
Characteristic.create!(name: "SW Friendly")
Characteristic.create!(name: "Vegan")
Characteristic.create!(name: "Intersex")
Characteristic.create!(name: "Clean Freak")
Characteristic.create!(name: "Abortion Friendly")
Characteristic.create!(name: "Drag Performer")
Characteristic.create!(name: "Sober")
Characteristic.create!(name: "Queer")
Characteristic.create!(name: "Sign Language")
Characteristic.create!(name: "Neurodiverse")
Characteristic.create!(name: "Vaccinated")
Characteristic.create!(name: "Wheelchair Accessibility")
Characteristic.create!(name: "Gender Nonconforming")

puts "#{Characteristic.count} characteristics created!"

# Facilities

puts "destroying & seeding facilities..."
Facility.destroy_all

couch = Facility.create(name: "couch")
file1 = File.open("app/assets/images/icons/couch.svg")
couch.svg.attach(io: file1, filename: "couch.svg", content_type: "image/svg")
couch.save!

bed = Facility.create(name: "bed")
file2 = File.open("app/assets/images/icons/bed.svg")
bed.svg.attach(io: file2, filename: "bed.svg", content_type: "image/svg")
bed.save!

extra_key = Facility.create(name: "extra key")
file3 = File.open("app/assets/images/icons/key.svg")
extra_key.svg.attach(io: file3, filename: "key.svg", content_type: "image/svg")
extra_key.save!

wifi = Facility.create(name: "wifi")
file5 = File.open("app/assets/images/icons/wifi.svg")
wifi.svg.attach(io: file5, filename: "wifi.svg", content_type: "image/svg")
wifi.save!

pets_allowed = Facility.create(name: "pets allowed")
file6 = File.open("app/assets/images/icons/pets.svg")
pets_allowed.svg.attach(io: file6, filename: "pets.svg", content_type: "image/svg")
pets_allowed.save!

shared_room = Facility.create(name: "shared room")
file7 = File.open("app/assets/images/icons/shared.svg")
shared_room.svg.attach(io: file7, filename: "shared-room.svg", content_type: "image/svg")
shared_room.save!

balcony = Facility.create(name: "balcony")
file8 = File.open("app/assets/images/icons/balcony.svg")
balcony.svg.attach(io: file8, filename: "balcony.svg", content_type: "image/svg")
balcony.save!

barrier_free = Facility.create(name: "barrier free")
file9 = File.open("app/assets/images/icons/barrier-free.svg")
barrier_free.svg.attach(io: file9, filename: "barrier-free.svg", content_type: "image/svg")
barrier_free.save!

elevator = Facility.create(name: "elevator")
file10 = File.open("app/assets/images/icons/elevator.svg")
elevator.svg.attach(io: file10, filename: "elevator.svg", content_type: "image/svg")
elevator.save!

private_room = Facility.create(name: "private room")
file11 = File.open("app/assets/images/icons/lock.svg")
private_room.svg.attach(io: file11, filename: "lock.svg", content_type: "image/svg")
private_room.save!

smoking_allowed = Facility.create(name: "smoking allowed")
file13 = File.open("app/assets/images/icons/smoking.svg")
smoking_allowed.svg.attach(io: file13, filename: "smoking.svg", content_type: "image/svg")
smoking_allowed.save!

puts "#{Facility.count} facilities created!"

# Create a base user to get started with the app. Use the email and password from the .env file!
user_email = ENV.fetch("BASE_USER_EMAIL", nil)
user_password = ENV.fetch("BASE_USER_PASSWORD", nil)
puts "Create first user"
User.destroy_all
base_user = User.new(
  email: user_email,
  password: user_password,
  first_name: "Admin",
  last_name: "Local",
  confirmed_at: Time.now
)

base_user.save!(validate: false)

Couch.create!(
  user: base_user
)

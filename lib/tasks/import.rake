require "open-uri"
require "tempfile"

Profile = Airrecord.table("", "", "Profiles")

namespace :import do
  desc "Import users from Airtable"

  task import: :environment do
    Profile.all(sort: {"CreatedDate" => "asc"}).each_with_index do |row, _index|
      # break if _index >= 100

      user = User.new
      user.email = row["Email"]
      user.password = "123456"
      user.first_name = row["First Name"].capitalize unless row["First Name"].nil?
      user.last_name = row["Last Name"].capitalize unless row["Last Name"].nil?
      user.pronouns = row["Pronouns"].downcase unless row["Pronouns"].nil?
      user.summary = row["Summary"]
      user.question_one = row["This makes me really happy"]
      user.question_two = row["What I can't stand"]
      user.question_three = row["When you live at my place, I appreciate...."]
      user.question_four = row["What I mostly need right now from the people around me"]
      add_offers(row["I can ..."], user) unless row["I can ..."].nil?
      user.date_of_birth = row["Birthdate"] unless row["Birthdate"].nil?
      user.country = row["Country"].strip.titleize unless row["Country"].nil?
      user.city = row["City"].strip.titleize unless row["City"].nil?
      user.address = "#{user.city}, #{user.country}"
      user.invite_code = row["Invitation Code"]
      invited_by = row["Used Invite Code"]
      user.invited_by_id = find_user(invited_by) unless invited_by.nil?
      user.characteristics = create_user_characteristics(row["Filter"], user) unless row["Filter"].nil?
      photo_url = row["Profile Picture"]
      attach_image(photo_url, user)
      user.save!(validate: false)
      couch = Couch.new(user_id: user.id)
      couch.save!(validate: false)
    end

    puts "Import finished. #{User.count} users created."
  end

  def attach_image(photo_url, user)
    return unless photo_url.is_a?(Array)

    url = photo_url[0]["url"]
    photo_filename = photo_url[0]["filename"]
    temp_file = Tempfile.new(photo_filename)

    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.scheme == "https"
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)

    if response.code.to_i == 200
      temp_file.binmode
      temp_file.write(response.body)
      temp_file.rewind

      begin
        # Upload the image to Cloudinary
        cloudinary_upload = Cloudinary::Uploader.upload(temp_file.path)

        # Get the public URL of the uploaded image from the Cloudinary response
        cloudinary_url = cloudinary_upload["secure_url"]

        # Attach the Cloudinary URL to user.photo
        user.photo.attach(io: URI.parse(cloudinary_url), filename: photo_filename).open
      rescue => e
        puts "Error uploading image to Cloudinary: #{e.message}"
      end
    else
      puts "Error fetching image: #{response.code} - #{response.message}"
    end

    temp_file.close
    temp_file.unlink
  end

  def find_user(invited_by)
    User.find_by(invite_code: invited_by.downcase)
  end

  def create_user_characteristics(row, user)
    characteristics = []
    usercharacteristics = []
    row.each do |char|
      characteristic = Characteristic.find_by(name: char)
      next if characteristic.nil?

      characteristics << characteristic
      usercharacteristic = UserCharacteristic.create(user_id: user.id, characteristic_id: characteristic.id)
      usercharacteristics << usercharacteristic
    end
    characteristics
  end

  def add_offers(row, user)
    user.offers_couch = row.include?("host")
    user.offers_hang_out = row.include?("hang out")
    user.offers_co_work = row.include?("co-work")
    user.travelling = row.include?("currently travelling")
  end
end

require 'csv'
require 'open-uri'
require 'tempfile'

namespace :import do
	desc 'Import users from CSV'

	task :import => :environment do
    path = ENV.fetch("CSV_FILE") {
      File.join(File.dirname(__FILE__), %w[.. .. db data users_images.csv])
    }
    CSV.foreach(path, headers: :first_row) do |row|
			user = User.new
			user.email = row['email']
			user.first_name = row['first_name']
			user.last_name = row['last_name']
			user.pronouns = row['pronouns']
			user.summary = row['summary']
			user.question_one = row['question_one']
			user.question_two = row['question_two']
			user.question_three = row['question_three']
			user.question_four = row['question_four']
			user.offers_couch = row['offers_couch']
			user.offers_hang_out = row['offers_hang_out']
			user.offers_co_work = row['offers_co_work']
			user.date_of_birth = row['date_of_birth'] if !row['date_of_birth'].nil?
			user.country = row['country']
			user.city = row['city']
			user.characteristics = create_user_characteristics(row['characteristics'], user) if !row['characteristics'].nil?
			photo_url = row['photo']
			attach_image(photo_url, user)
			user.save!(validate: false)
			couch = Couch.new(user_id: user.id)
			couch.save!(validate: false)
    end
  end

	def attach_image(photo_url, user)
		if photo_url
			url_regex = /https:\/\/airtable\.com\/.+?(?=\))/
			url = photo_url.match(url_regex)[0].to_s
			photo_filename = File.basename(url)

			temp_file = Tempfile.new(photo_filename)

			uri = URI.parse(url)
			http = Net::HTTP.new(uri.host, uri.port)
			http.use_ssl = true if uri.scheme == 'https'
			request = Net::HTTP::Get.new(uri.request_uri)
			request['Authorization'] = 'Bearer keyrIce3j9tcNJk4g'
			response = http.request(request)

			if response.code.to_i == 200
				temp_file.binmode
				temp_file.write(response.body)
				temp_file.rewind
				puts "Saved image file: #{temp_file.path}"
				puts "Image file size: #{temp_file.size} bytes"

				# Attach the image to user.photo
				user.photo.attach(io: temp_file, filename: photo_filename)
			else
				puts "Error fetching image: #{response.code} - #{response.message}"
			end
		end
	end

	def create_user_characteristics(row, user)
		characteristics = []
		usercharacteristics = []
		row.split(',').each do |char|
			characteristic = Characteristic.find_by(name: char.strip)
			next if characteristic.nil?
			p characteristic
			characteristics << characteristic
      usercharacteristic = UserCharacteristic.create(user_id: user.id, characteristic_id: characteristic.id)
     usercharacteristics << usercharacteristic
    end
   characteristics
	end
end

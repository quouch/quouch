namespace :booking do
  desc "Complete past Bookings and remind hosts about open requests"

  task complete: :environment do
    Booking.complete
  end

  task remind: :environment do
    Booking.remind
  end
end

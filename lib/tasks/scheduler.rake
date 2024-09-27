namespace :bookings do
  desc 'Complete past bookings and remind hosts about open requests'

  task process: :environment do
    BookingsJob.perform_now
  end
end

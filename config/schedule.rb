# Complete bookings once end_date has passed
every 1.day, at: '11:59 pm' do
	rake 'booking:complete'
end

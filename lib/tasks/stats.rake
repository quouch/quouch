namespace :stats do
	desc 'Send user statistics'

	task send: :environment do
		StatisticsMailer.send_stats.deliver_now
	end
end

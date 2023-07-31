class BookingsController < ApplicationController
	before_action :set_booking, except: %i[index requests new create]
	before_action :set_couch, only: %i[new create requests]

	def index
		@bookings = Booking.includes(couch: [user: [{ photo_attachment: :blob }]]).where(user: current_user)
		@upcoming = @bookings.select { |booking| booking.confirmed? || booking.pending? || booking.pending_reconfirmation? }.sort_by { |booking| booking.start_date || Date.today }
		@cancelled = @bookings.select { |booking| booking.cancelled? || booking.declined? }.sort_by { |booking| booking.start_date || Date.today }
		@completed = @bookings.select(&:completed?).sort_by { |booking| booking.start_date || Date.today }
	end

	def requests
    @requests = @couch.bookings
		@upcoming = @requests.select { |request| request.confirmed? || request.pending? || request.pending_reconfirmation? }.sort_by { |request| request.start_date || Date.today }
		@cancelled = @requests.select { |request| request.cancelled? || request.declined? }.sort_by { |request| request.start_date || Date.today }
		@completed = @requests.select(&:completed?).sort_by { |request| request.start_date || Date.today }
	end

	def show
		@couch = @booking.couch
		@host = @couch.user
		@guest = @booking.user
		@hosts_array = User.where(id: @host.id)
		@review = Review.new
		@marker = @hosts_array.geocoded.map do |host|
			{
					lat: host.latitude,
					lng: host.longitude,
					marker_html: render_to_string(partial: 'marker')
			}
		end
		@chat = Chat.find_by(user_sender_id: @host.id, user_receiver_id: @guest.id) ||
						Chat.find_by(user_sender_id: @guest.id, user_receiver_id: @host.id)
		@host_review = @booking.reviews.find_by(user: @host)
		@guest_review = @booking.reviews.find_by(user: @booking.user)
	end

	def new
		@booking = Booking.new
		@host = @couch.user
		offers(@host)
	end

	def create
		@booking = Booking.new(booking_params)
		@booking.couch = @couch
		@guest = @booking.user
		@host = @couch.user
		@booking.user = current_user
		@booking.booking_date = DateTime.now
		if @booking.save
			@booking.pending!
			redirect_to sent_booking_path(@booking)
			BookingMailer.with(booking: @booking).new_request_email.deliver_later
		else
			offers(@host)
			render :new, status: :unprocessable_entity
		end
	end

	def edit
		@host = @booking.couch.user
		offers(@host)
	end

	def update
		@booking.update(booking_params)
		if @booking.pending?
			flash[:notice] = 'Request successfully updated!'
			BookingMailer.with(booking: @booking).request_updated_email.deliver_later
		elsif @booking.confirmed?
			flash[:notice] = 'Booking successfully updated!'
			@booking.pending!
			BookingMailer.with(booking: @booking).booking_updated_email.deliver_later
		end
		redirect_to booking_path(@booking)
	end

	def cancel
		status_before_cancellation = @booking.status
		@booking.cancelled!
		@booking.cancellation_date = DateTime.now
		@canceller = current_user
		if @booking.save
			if @canceller == @booking.user
				redirect_to bookings_path
				case status_before_cancellation
				when 'pending'
					BookingMailer.with(booking: @booking).request_cancelled_email.deliver_later
				when 'confirmed'
					BookingMailer.with(booking: @booking).booking_cancelled_by_guest_email.deliver_later
				end
			else
				redirect_to requests_couch_bookings_path(@booking.couch)
				BookingMailer.with(booking: @booking).booking_cancelled_by_host_email.deliver_later
			end
		end
	end

	def show_request
		@review = Review.new
		@couch = @booking.couch
		@host = @couch.user
		@guest = @booking.user
		@chat = Chat.find_by(user_sender_id: @guest.id, user_receiver_id: @host.id) || Chat.find_by(user_sender_id: @host.id, user_receiver_id: @guest.id)
		@host_review = @booking.reviews.find_by(user: @host)
		@guest_review = @booking.reviews.find_by(user: @booking.user)
	end

	def sent
		@host = @booking.couch.user
		@couch = @booking.couch
		@booking = Booking.find(params[:id])
	end

	def confirmed
		@guest = @booking.user
	end

	def accept
		if @booking.confirmed!
			BookingMailer.with(booking: @booking).request_confirmed_email.deliver_later
			redirect_to confirmed_booking_path(@booking)
		end
	end

	def decline
		if @booking.declined!
			redirect_to requests_couch_bookings_path(@booking.couch)
			BookingMailer.with(booking: @booking).request_declined_email.deliver_later
		end
	end

	def complete
		@booking = Booking.find(params[:id])
		@booking.completed!
		BookingMailer.with(booking: @booking).booking_completed_guest_email.deliver_later
		BookingMailer.with(booking: @booking).booking_completed_host_email.deliver_later
		redirect_to booking_path(@booking)
	end

		private

	def booking_params
		params.require(:booking).permit(:request, :start_date, :end_date, :number_travellers, :message, :flexible)
	end

	def set_booking
		@booking = Booking.find(params[:id])
	end

	def set_couch
		@couch = Couch.includes(:bookings).find(params[:couch_id])
	end

	def offers(host)
		if host.offers_couch && host.offers_hang_out && host.offers_co_work
			@offers = { host: 0, hangout: 1, cowork: 2 }
		elsif host.offers_couch && host.offers_hang_out
			@offers = { host: 0, hangout: 1 }
		elsif host.offers_couch && host.offers_co_work
			@offers = { host: 0, cowork: 2 }
		elsif host.offers_hang_out && host.offers_co_work
			@offers = { hangout: 1, cowork: 2 }
		elsif host.offers_couch
			@offers = { host: 0 }
		elsif host.offers_hang_out
			@offers = { hangout: 1 }
		elsif host.offers_co_work
			@offers = { cowork: 2 }
		end
	end
end

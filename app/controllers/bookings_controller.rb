class BookingsController < ApplicationController
	before_action :set_booking, except: %i[index requests new create]
	before_action :set_couch, only: %i[new create requests]

	def index
		@bookings = Booking.includes(couch: [user: [{ photo_attachment: :blob }]]).where(user: current_user)
		@upcoming = @bookings.select do |booking|
 booking.confirmed? || booking.pending? || booking.pending_reconfirmation?
              end.sort_by { |booking| booking.start_date || Date.today }
		@cancelled = @bookings.select do |booking|
 booking.cancelled? || booking.declined?
               end.sort_by { |booking| booking.start_date || Date.today }
		@completed = @bookings.select(&:completed?).sort_by { |booking| booking.start_date || Date.today }
	end

	def requests
    @requests = @couch.bookings
		@upcoming = @requests.includes(:user).select do |request|
			request.confirmed? || request.pending? || request.pending_reconfirmation?
    	end.sort_by { |request| request.start_date || Date.today }
		@cancelled = @requests.includes(:user).select do |request|
 			request.cancelled? || request.declined?
      end.sort_by { |request| request.start_date || Date.today }
		@completed = @requests.includes(:user).select(&:completed?).sort_by { |request| request.start_date || Date.today }
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
		return unless @booking.save

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

	def show_request
		@review = Review.new
		@couch = @booking.couch
		@host = @couch.user
		@guest = @booking.user
		@chat = Chat.find_by(user_sender_id: @guest.id,
                       user_receiver_id: @host.id) || Chat.find_by(user_sender_id: @host.id,
                                                                   user_receiver_id: @guest.id)
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
		return unless @booking.confirmed!

		BookingMailer.with(booking: @booking).request_confirmed_email.deliver_later
	end

	def decline
		return unless @booking.declined!

		redirect_to requests_couch_bookings_path(@booking.couch)
		BookingMailer.with(booking: @booking).request_declined_email.deliver_later
	end

	def complete
		@booking = Booking.find(params[:id])
		@booking.completed!
		BookingMailer.with(booking: @booking).booking_completed_guest_email.deliver_later
		BookingMailer.with(booking: @booking).booking_completed_host_email.deliver_later
		redirect_to booking_path(@booking)
	end

	def decline_and_send_message
		if chat = Chat.find_by(user_sender_id: @booking.user.id, user_receiver_id: current_user.id) ||
			Chat.find_by(user_sender_id: current_user.id, user_receiver_id: @booking.user.id)
			Message.create(user_id: current_user.id, chat:)
		else
			chat = Chat.create(user_sender_id: current_user.id, user_receiver_id: @booking.user.id)
			Message.create(user_id: current_user.id, chat_id: chat.id)
		end
		decline
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
		@offers = {}

		@offers[:host] = 0 if host.offers_couch
		@offers[:hangout] = 1 if host.offers_hang_out
		@offers[:cowork] = 2 if host.offers_co_work

		@offers
	end

	def cancel_booking(canceller, booking, status_before_cancellation)
		if canceller == booking.user
			redirect_to bookings_path
			case status_before_cancellation
			when 'pending'
				BookingMailer.with(booking:).request_cancelled_email.deliver_later
			when 'confirmed'
				BookingMailer.with(booking:).booking_cancelled_by_guest_email.deliver_later
			end
		else
			redirect_to requests_couch_bookings_path(booking.couch)
			BookingMailer.with(booking:).booking_cancelled_by_host_email.deliver_later
		end
	end
end

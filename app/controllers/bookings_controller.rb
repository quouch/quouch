class BookingsController < ApplicationController
	before_action :set_booking, except: %i[index requests new create]
	before_action :set_couch, only: %i[new create]

	def index
		@bookings = Booking.all.where(user: current_user)
	end

	def requests
		@requests = Booking.all.select { |booking| booking.couch.user == current_user }
	end

	def show
		@payment = @booking.payments.where(operation: 1)
		@couch = @booking.couch
	end

	def new
		@booking = Booking.new
	end

	def create
		@booking = Booking.new(booking_params)
    @booking.couch = @couch
    @booking.user = current_user
		@booking.pending!
		@booking.booking_date = DateTime.now
		@booking.nights = (@booking.end_date - @booking.start_date).to_i
		if @booking.save
      redirect_to sent_booking_path(@booking), notice: "Your request has been sent."
			BookingMailer.with(booking: @booking).new_request_email.deliver_later
    else
      render 'bookings/new'
    end
	end

	def edit
	end

	def update
		@booking.nights = (@booking.end_date - @booking.start_date).to_i
		@booking.update(booking_params)
		if @booking.pending?
			BookingMailer.with(booking: @booking).request_updated_email.deliver_later
		elsif @booking.confirmed?
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
				when'confirmed'
					refund(@booking)
					BookingMailer.with(booking: @booking).booking_cancelled_by_guest_email.deliver_later
				end
			else
				redirect_to requests_couch_bookings_path(@booking.couch)
				BookingMailer.with(booking: @booking).booking_cancelled_by_host_email.deliver_later
			end
		end
	end

	def show_request
	end

	def sent
		@host = @booking.couch.user
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
			BookingMailer.with(booking: @booking).booking_declined_email.deliver_later
		end
  end

	def pay
		customer = Stripe::Customer.create(
			address: @booking.user.address,
			email: @booking.user.email,
			name: "#{@booking.user.first_name} #{@booking.user.last_name}"
		)

		setup = Stripe::SetupIntent.create({
			payment_method_types: ['card'],
			customer: customer.id,
			metadata: {
				booking: @booking.id,
			},
		})

		session = Stripe::Checkout::Session.create(
			payment_method_types: ['card'],
			# line_items: [{
			# 	price_data: {
			# 		currency: 'eur',
			# 		product_data: {
			# 			name: "Stay with #{@booking.couch.user.first_name}",
			# 		},
			# 		unit_amount: 100,
			# 	},
			# 	quantity: @booking.nights,
			# }],
			customer: customer.id,
			mode: 'setup',
			setup_intent: setup,
			success_url: booking_url(@booking),
			cancel_url: bookings_url
		)

		@payment = Payment.create(checkout_session_id: session.id, amount_cents: @booking.nights * 100, operation: 1, status: 0)
		BookingPayment.create(booking: @booking, payment: @payment)
		redirect_to new_booking_payment_path(@booking)
	end

	private

	def booking_params
		params.require(:booking).permit(:start_date, :end_date, :number_travellers, :message)
	end

	def set_booking
		@booking = Booking.find(params[:id])
	end

	def set_couch
		@couch = Couch.find(params[:couch_id])
	end
end

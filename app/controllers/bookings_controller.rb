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
	end

	def new
		@booking = Booking.new
	end

	def create
		@booking = Booking.new(booking_params)
    @booking.couch = @couch
    @booking.user = current_user
		@booking.status = 0
		@booking.booking_date = DateTime.now
		@booking.price_cents = (@booking.end_date - @booking.start_date).to_i
		price = 100
		nights = (@booking.end_date - @booking.start_date).to_i
		@booking.save!
		# @booking.amount_cents = price

		session = Stripe::Checkout::Session.create(
			payment_method_types: ['card'],

			# line_items: [{
			# 	price_data: {
			# 		currency: 'eur',
			# 		product_data: {
			# 			name: "Stay with #{@booking.couch.user.first_name}",
			# 		},
			# 		unit_amount: price,
			# 	},
			# 	quantity: nights,
			# }],
			mode: 'setup',
			success_url: sent_booking_url(@booking),
			cancel_url: bookings_url
		)

		@booking.update(checkout_session_id: session.id, amount_cents: price)
		redirect_to new_booking_payment_path(@booking)
	end

	def pay
	end

	def edit
	end

	def update
		@booking.price_cents = @booking.end_date - @booking.start_date
		@booking.update(booking_params)
		redirect_to booking_path(@booking)
	end

	def cancel
		@booking.status = -1
		@booking.cancellation_date = DateTime.now
		@canceller = current_user
		@booking.save
		if @canceller == @booking.user
			redirect_to bookings_path
		elsif @booking.update
			redirect_to requests_couch_bookings_path(@booking.couch)
		end
	end

	def show_request
	end

	def sent
		@host = @booking.couch.user
	end

	def accept
    @booking.update(status: 1)
  end

  def decline
    @booking.update(status: 2)
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

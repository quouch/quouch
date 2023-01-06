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
		@booking.booking_status = 0
		@booking.payment_status = 0
		@booking.booking_date = DateTime.now
		if @booking.save
      redirect_to sent_booking_path(@booking), notice: "Your request has been sent."
			BookingMailer.with(booking: @booking).new_request_email.deliver_later
    else
      render 'bookings/new'
    end
	end

	def pay
		nights = (@booking.end_date - @booking.start_date).to_i
		@booking.price_cents = nights
		price = 100

		session = Stripe::Checkout::Session.create(
			payment_method_types: ['card'],

			line_items: [{
				price_data: {
					currency: 'eur',
					product_data: {
						name: "Stay with #{@booking.couch.user.first_name}",
					},
					unit_amount: price,
				},
				quantity: nights,
			}],
			mode: 'payment',
			success_url: booking_url(@booking),
			cancel_url: bookings_url
		)

		@booking.update(checkout_session_id: session.id, amount_cents: price * nights)
		redirect_to new_booking_payment_path(@booking)
	end

	def edit
	end

	def update
		case @booking.booking_status
			when 'pending'
				@booking.update(booking_params)
				BookingMailer.with(booking: @booking).request_updated_email.deliver_later
			when'confirmed'
				old_amount_nights = @booking.price_cents
				@booking.update(booking_params)
				new_amount_nights = (@booking.end_date - @booking.start_date).to_i
				difference_nights = old_amount_nights - new_amount_nights
				payment_or_refund?(difference_nights) if amount_nights_changed?(difference_nights, new_amount_nights, @booking)
				raise
				BookingMailer.with(booking: @booking).booking_updated_email.deliver_later
		end
		redirect_to booking_path(@booking)
	end

	def cancel
		status_before_cancellation = @booking.booking_status
		@booking.booking_status = -1
		@booking.cancellation_date = DateTime.now
		@canceller = current_user
		if @booking.update
			if @canceller == @booking.user
				redirect_to bookings_path
				case status_before_cancellation
					when 'pending'
						BookingMailer.with(booking: @booking).request_cancelled_email.deliver_later
					when'confirmed'
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
    if @booking.update(booking_status: 1)
			BookingMailer.with(booking: @booking).request_confirmed_email.deliver_later
			redirect_to confirmed_booking_path(@booking)
		end
  end

  def decline
    if @booking.update(booking_status: 2)
			BookingMailer.with(booking: @booking).booking_declined_email.deliver_later
		end
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

	def amount_nights_changed?(difference_nights, new_amount_nights, booking)
		if difference_nights != 0
			booking.price_cents = new_amount_nights
			booking.update(amount_cents: new_amount_nights * 100)
		end
	end

	def payment_or_refund?(difference_nights)
		if difference_nights.negative?
			@booking.payment_status = 2
			Stripe::Refund.create({
				amount: difference_nights * 100,
				# payment_intent: 
			})
		else
			@booking.payment_status = 3
			@booking.booking_status = 3
			# new payment auftrag
		end
	end
end

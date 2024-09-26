class AmplitudeEventTracker
  def self.track_booking_event(booking, event_type)
    event = AmplitudeAPI::Event.new(
      user_id: booking.user.id.to_s,
      event_type:,
      couch: booking.couch_id,
      booking: booking.id,
      flexible: booking.flexible,
      request: booking.request,
      status: booking.status,
      start_date: booking.start_date,
      end_date: booking.end_date,
      number_travellers: booking.number_travellers,
      time: Time.now
    )
    AmplitudeAPI.track(event)
  end

  def self.track_contact_event(params, event_type)
    event = AmplitudeAPI::Event.new(
      user_id: 'not_logged_in',
      event_type:,
      source: params[:contact][:source],
      message: params[:contact][:message],
      time: Time.now
    )
    AmplitudeAPI.track(event)
  end

  def self.track_message_event(event_type)
    user_id = if current_user
                current_user.id.to_s
              else
                'not_logged_in'
              end
    event = AmplitudeAPI::Event.new(
      user_id:,
      event_type:,
      time: Time.now
    )
    AmplitudeAPI.track(event)
  end

  def self.track_review_event(review, event_type)
    user_id = if current_user
                current_user.id.to_s
              else
                'not_logged_in'
              end
    event = AmplitudeAPI::Event.new(
      user_id:,
      event_type:,
      rating: review.rating,
      couch: review.couch.id,
      booking: review.booking.id,
      time: Time.now
    )
    AmplitudeAPI.track(event)
  end

  def self.track_user_event(user, event_type)
    event = AmplitudeAPI::Event.new(
      user_id: user.id.to_s,
      event_type:,
      user_properties: {
        age: user.calculated_age,
        country: user.country,
        host: user.offers_couch,
        travelling: user.travelling,
        invited_by: user.invited_by_id
      },
      time: Time.now
    )
    AmplitudeAPI.track(event)
  end
end

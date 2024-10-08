# This concern is used to filter the couches on the index page based on the search query, characteristics and offers.
module CouchesConcern
  extend ActiveSupport::Concern

  included do
    include Pagy::Backend
  end

  def find_and_filter
    session[:seed] ||= rand
    session_seed = session[:seed]
    Couch.select("setseed(#{session_seed})").first

    filter_couches

    items = params[:items] || 9

    @pagy, @couches = pagy(@shuffled_couches, items:)
  end

  private

  def filter_couches
    @shuffled_couches = Couch.includes(:reviews, user: [{ photo_attachment: :blob }, :characteristics])
                             .joins(:user)
                             .where(active: true)
                             .where.not(user: current_user)
                             .where(user: { travelling: false })
                             .where.not(user: { first_name: nil, city: nil, country: nil })
                             .order('RANDOM()')

    apply_search_filter if params[:query].present?
    apply_characteristics_filter if params[:characteristics].present?
    apply_offers_filter if params.keys.any? { |key| key.to_s.include?('offers') }

    @shuffled_couches
  end

  def apply_search_filter
    @shuffled_couches = @shuffled_couches.search_by_location(params[:query])
                                         # use .reorder to eliminate the order by ranking that pg_search creates.
                                         # The pg_search.rank ordering conflicts with the `group` and `having` clauses introduced by the characteristics filter
                                         .reorder('RANDOM()')
  end

  def apply_characteristics_filter
    @shuffled_couches = @shuffled_couches.joins(user: { user_characteristics: :characteristic })
                                         .where(characteristics: { id: params[:characteristics] })
                                         .group('couches.id')
                                         .having('COUNT(DISTINCT characteristics.id) = ?', params[:characteristics].length)
  end

  def apply_offers_filter
    offers_conditions = {}

    offers_conditions[:offers_hang_out] = true if params[:offers_hang_out]
    offers_conditions[:offers_co_work] = true if params[:offers_co_work]
    offers_conditions[:offers_couch] = true if params[:offers_couch]
    offers_conditions[:travelling] = false

    @shuffled_couches = @shuffled_couches.joins(:user).where(user: offers_conditions)
  end

  def get_user_photo(user)
    user.photo.attached? ? url_for(user.photo) : nil
  end

  def randomly_haze(coord)
    coord + rand(-0.011..0.011)
  end

  def couch_to_marker(couch)
    return unless couch.user.geocoded?
    return if couch.hide_from_map

    hazy_lng = randomly_haze(couch.user.longitude)
    hazy_lat = randomly_haze(couch.user.latitude)

    {
      fuzzy: "#{couch.user.zipcode}, #{couch.user.city}, #{couch.user.country}",
      id: couch.id,
      lng: hazy_lng,
      lat: hazy_lat,
      info_popup: {
        data: {
          first_name: couch.user.first_name,
          last_name: couch.user.last_name,
          # rating: couch.rating,
          photo: get_user_photo(couch.user),
          pronouns: couch.user.pronouns
        }
      }
    }
  end

end

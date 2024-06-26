class CouchesController < ApplicationController
  def index
    @unfiltered_couches = Couch.includes(:reviews, user: [{ photo_attachment: :blob }, :characteristics])
                               .joins(:user)
                               .where.not(user: current_user)
                               .where.not(user: { first_name: nil, city: nil, country: nil })

    @shuffled_couches = @unfiltered_couches.order('RANDOM()')
    @pagy, @couches = pagy(@shuffled_couches, items: 9)

    apply_search_filter if params[:query].present?
    apply_characteristics_filter if params[:characteristics].present?
    apply_offers_filter if params.keys.any? { |key| key.include?('offers') }

    @pagy, @couches = pagy(@shuffled_couches, items: 9)

    respond_to do |format|
      format.html
      format.json
    end
  end

  def show
    @couch = Couch.find(params[:id])
    @host = User.find(@couch.user.id)
    @reviews = Review.where(couch_id: params[:id])
    @review_average = @reviews.average(:rating).to_f
    @chat = Chat.find_by(user_sender_id: @host.id, user_receiver_id: current_user.id) ||
            Chat.find_by(user_sender_id: current_user.id, user_receiver_id: @host.id)
  end

  def search_cities
    query = params[:q].presence&.downcase
    cities = []
    countries = []

    if query.present?
      cities = User.search_city_or_country(query).pluck(:city).uniq.compact.sort
      countries = User.search_city_or_country(query).pluck(:country).uniq.compact.sort
    end

    @results = (cities + countries).select { |entry| entry.downcase.starts_with?(query) }
    render layout: false
  end

  private

  def apply_search_filter
    @shuffled_couches = @shuffled_couches.search(params[:query])
  end

  def apply_characteristics_filter
    @shuffled_couches = @shuffled_couches.joins(user: { user_characteristics: :characteristic })
                                         .where(characteristics: { id: params[:characteristics] })
                                         .group('couches.id')
                                         .having('COUNT(DISTINCT characteristics.id) = ?', params[:characteristics].length)
                                         .reorder('RANDOM()')
  end

  def apply_offers_filter
    offers_conditions = {}

    offers_conditions[:offers_hang_out] = true if params[:offers_hang_out]
    offers_conditions[:offers_co_work] = true if params[:offers_co_work]
    offers_conditions[:offers_couch] = true if params[:offers_couch]
    offers_conditions[:travelling] = false

    @shuffled_couches = @shuffled_couches.joins(:user).where(user: offers_conditions) if offers_conditions.any?
  end
end

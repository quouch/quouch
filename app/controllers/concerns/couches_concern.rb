# This concern is used to filter the couches on the index page based on the search query, characteristics and offers.
module CouchesConcern
  extend ActiveSupport::Concern

  included do
    include Pagy::Backend
  end

  def index
    session[:seed] ||= rand
    session_seed = session[:seed]
    Couch.select("setseed(#{session_seed})").first

    @shuffled_couches = Couch.includes(:reviews, user: [{photo_attachment: :blob}, :characteristics])
      .joins(:user)
      .where.not(user: current_user)
      .where.not(user: {first_name: nil, city: nil, country: nil})
      .order("RANDOM()")

    apply_search_filter if params[:query].present?
    apply_characteristics_filter if params[:characteristics].present?
    apply_offers_filter if params.keys.any? { |key| key.include?("offers") }

    items = params[:items] || 9

    @pagy, @couches = pagy(@shuffled_couches, items:)
  end

  private

  def apply_search_filter
    @shuffled_couches = @shuffled_couches.search(params[:query])
  end

  def apply_characteristics_filter
    @shuffled_couches = @shuffled_couches.joins(user: {user_characteristics: :characteristic})
      .where(characteristics: {id: params[:characteristics]})
      .group("couches.id")
      .having("COUNT(DISTINCT characteristics.id) = ?", params[:characteristics].length)
  end

  def apply_offers_filter
    offers_conditions = {}

    offers_conditions[:offers_hang_out] = true if params[:offers_hang_out]
    offers_conditions[:offers_co_work] = true if params[:offers_co_work]
    offers_conditions[:offers_couch] = true if params[:offers_couch]
    offers_conditions[:travelling] = false

    @shuffled_couches = @shuffled_couches.joins(:user).where(user: offers_conditions)
  end
end

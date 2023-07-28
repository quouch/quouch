class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[home about search_city]

  def home
    @couches = Couch.joins(:user)
                    .where.not(users: { first_name: nil })
                    .where.not(users: { city: nil })
                    .where.not(users: { country: nil })
                    .where.not(user: current_user)

    @active_couches = @couches.includes(:reviews, user: [{ photo_attachment: :blob }, :characteristics])
                              .page(params[:page])
                              .per(31)

    apply_search_filter if params[:query].present?
    apply_characteristics_filter if params[:characteristics].present?
    apply_offers_filter if params.keys.any? { |key| key.include?('offers') }

    @active_couches = @active_couches.page(params[:page]).per(30)
  end

  def search_cities
    query = params[:q].presence&.downcase
    cities = []
    countries = []

    if query.present?
      cities = User.search_city_or_country(query).pluck(:city).uniq.sort
      countries = User.search_city_or_country(query).pluck(:country).uniq.sort
    end

    @results = (cities + countries).select { |entry| entry.downcase.starts_with?(query) }
    render layout: false
  end

  def apply_search_filter
    @active_couches = @active_couches.search(params[:query])
  end

  def apply_characteristics_filter
    @active_couches = @active_couches.joins(user: { user_characteristics: :characteristic })
                                     .where(characteristics: { id: params[:characteristics] })
                                     .group('couches.id')
                                     .having('COUNT(DISTINCT characteristics.id) = ?', params[:characteristics].length)
                                     .reorder(nil)
  end

  def apply_offers_filter
    offers_conditions = {}

    offers_conditions[:offers_hang_out] = true if params[:offers_hang_out]
    offers_conditions[:offers_co_work] = true if params[:offers_co_work]
    offers_conditions[:offers_couch] = true if params[:offers_couch]
    offers_conditions[:travelling] = false

    @active_couches = @active_couches.joins(:user).where(user: offers_conditions) if offers_conditions.any?
  end
end

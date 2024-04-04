require 'csv'

class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[home about search_city faq guidelines safety privacy impressum terms]
  before_action :authenticate, only: [:emails]

  def home
    @couches = Couch.includes(:reviews, user: [{ photo_attachment: :blob }, :characteristics])
                    .joins(:user)
                    .where.not(user: current_user)
                    .where.not(user: { first_name: nil })
                    .where.not(user: { city: nil })
                    .where.not(user: { country: nil })

    @shuffled_couches = @couches.includes(:reviews, user: [{ photo_attachment: :blob }, :characteristics]).shuffle
    @active_couches = Kaminari.paginate_array(@shuffled_couches).page(params[:page]).per(30)
    @active_unshuffled_couches = @couches.includes(:reviews, user: [{ photo_attachment: :blob }, :characteristics])

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
    @active_couches = @active_unshuffled_couches.search(params[:query])
  end

  def apply_characteristics_filter
    @active_couches = @active_unshuffled_couches.joins(user: { user_characteristics: :characteristic })
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

    @active_couches = @active_unshuffled_couches.joins(:user).where(user: offers_conditions) if offers_conditions.any?
  end

  def emails
    csv_data = CSV.generate(headers: true) do |csv|
      csv << ['Email']
      User.pluck(:email).each do |email|
        csv << [email]
      end
    end

    send_data csv_data, filename: 'emails.csv', type: 'text/csv'
  end

  private

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == 'admin' && password == ENV['EMAIL_EXPORT_PASSWORD']
    end
  end
end

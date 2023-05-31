class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[home about]

  def home
    @couches = Couch.where.not(user: current_user)
    @active_couches = @couches.includes(:reviews, user: [{ photo_attachment: :blob }, :characteristics])
  end

  def search_cities
    @cities = params[:q].present? ? User.search_city(params[:q]).pluck(:city).uniq.sort : User.pluck(:city).uniq.sort
    render layout: false
  end
end

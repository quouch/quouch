# frozen_string_literal: true

require_relative "concerns/couches_concern"

# CouchesController: This controller is responsible for handling the couches.
class CouchesController < ApplicationController
  include CouchesConcern
  respond_to :html

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
end

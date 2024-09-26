# frozen_string_literal: true

require 'api_test_helper'

class ReviewsEndpointTest < ApiEndpointTest
  def setup
    @user, @headers = api_prepare_headers

    @host = FactoryBot.create(:user, :offers_couch)

    @booking = FactoryBot.create(:booking, user: @user, couch: @host.couch)

    @review = Review.create!(content: 'Great experience', rating: 5, booking: @booking, user: @user, couch: @host.couch)
  end

  test 'GET /reviews' do
    get "/api/v1/users/#{@host.id}/reviews", headers: @headers
    assert_response :ok

    assert_match_openapi_doc
  end

  test 'GET /reviews without authentication' do
    get "/api/v1/users/#{@host.id}/reviews"
    assert_response :unauthorized

    assert_match_openapi_doc
  end

  test 'GET /reviews for non-existent chat' do
    get '/api/v1/users/999/reviews', headers: @headers
    assert_response :not_found

    assert_match_openapi_doc
  end
end

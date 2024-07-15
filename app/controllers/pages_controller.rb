require "csv"

class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[home about faq guidelines safety privacy impressum terms]
  before_action :authenticate, only: [:emails]

  def emails
    csv_data = CSV.generate(headers: true) do |csv|
      csv << ["Email"]
      User.pluck(:email).each do |email|
        csv << [email]
      end
    end

    send_data csv_data, filename: "emails.csv", type: "text/csv"
  end

  private

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == "admin" && password == Rails.application.credentials.dig(:email, :export_password)
    end
  end
end

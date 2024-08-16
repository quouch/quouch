# frozen_string_literal: true

require 'test_helper'

class RegistrationConcernTest < ActiveSupport::TestCase
  include RegistrationConcern

  setup do
    @user = FactoryBot.create(:user)
  end

  test "should beautify all countries in the addresses" do
    ADDRESSES.each do |address|
      params[:user] = {
        country: address[:country_code]
      }

      assert_equal address[:country], beautify_country
    end
  end

  def params
    @params ||= {}
  end

  def session
    @session ||= {}
  end
end

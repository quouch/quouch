# frozen_string_literal: true

require 'minitest/autorun'
require 'test_helper'

class CouchesConcernTest < ActiveSupport::TestCase
  include CouchesConcern

  setup do
    # Create the current user
    @user = FactoryBot.create(:test_user)
    Couch.create!(user: @user)
  end

  test 'should get index' do
    index
    assert_not_nil @couches
  end

  test 'should not find the current user' do
    index
    assert_equal 0, @couches.length
  end

  test 'should return no results if city is not found' do
    # Create at least one couch
    @host = FactoryBot.create(:test_user)
    @couch = Couch.create!(user: @host)

    # Filter for a city that doesn't exist
    params[:query] = 'Nonexistent City'
    index

    # Add assertions to check that the search filter was applied correctly
    assert_equal 0, @couches.length
  end

  test 'should search by city' do
    # Create at least one couch
    @host = FactoryBot.create(:test_user)
    @couch = Couch.create!(user: @host)

    # Filter by city
    city = @host[:city]
    params[:query] = city
    index

    # Add assertions to check that the search filter was applied correctly
    assert_equal @couches.length, 1
    assert_equal @couches.first, @couch
  end

  test 'should apply characteristics filter' do
    # Create two couches
    @host = FactoryBot.create(:test_user)
    @couch = Couch.create!(user: @host)

    @host2 = FactoryBot.create(:test_user)
    Couch.create!(user: @host2)

    # Create a characteristic and assign it to only one host
    characteristic = Characteristic.create!(name: 'Test Characteristic')
    @host.user_characteristics.create!(characteristic:)

    # Check that the characteristics filter is not applied when no characteristics are selected
    index
    assert_equal 2, @couches.length, 2

    # Set up necessary conditions for the characteristics filter
    params[:characteristics] = [characteristic.id]
    index
    # Add assertions to check that the characteristics filter was applied correctly
    assert_equal 1, @couches.length
  end

  test 'should only return couches that offer hang out' do
    # Create two couches
    @host = FactoryBot.create(:test_user)
    @host.offers_hang_out = true
    @host.save!
    @couch = Couch.create!(user: @host)

    @host2 = FactoryBot.create(:test_user)
    @host2.offers_hang_out = false
    @host2.save!
    Couch.create!(user: @host2)

    # Set up necessary conditions for the offers filter
    params[:offers_hang_out] = true
    index

    # Add assertions to check that the offers filter was applied correctly
    assert_equal 1, @couches.length
    assert_equal [@couch], @couches
  end

  test 'should only return couches that offer co work' do
    # Create two couches
    @host = FactoryBot.create(:test_user)
    @host.offers_co_work = false
    @host.save!
    @couch = Couch.create!(user: @host)

    @host2 = FactoryBot.create(:test_user)
    @host2.offers_co_work = false
    @host2.save!
    Couch.create!(user: @host2)

    # Set up necessary conditions for the offers filter
    params[:offers_hang_out] = true
    index

    # Add assertions to check that the offers filter was applied correctly
    assert_equal 0, @couches.length
  end

  test 'should only return couches that offer a couch' do
    # Create two couches
    @host = FactoryBot.create(:test_user)
    @host.offers_couch = true
    @host.save!
    @couch = Couch.create!(user: @host)

    @host2 = FactoryBot.create(:test_user)
    @host2.offers_couch = false
    @host2.save!
    Couch.create!(user: @host2)

    # Set up necessary conditions for the offers filter
    params[:offers_couch] = true
    index

    # Add assertions to check that the offers filter was applied correctly
    assert_equal 1, @couches.length
  end

  private

  def params
    @params ||= {}
  end

  def session
    @session ||= {}
  end

  def current_user
    @user
  end
end

# frozen_string_literal: true

require 'test_helper'

class CouchesConcernTest < ActiveSupport::TestCase
  include CouchesConcern

  setup do
    # Clear the database
    User.destroy_all
    Couch.destroy_all

    # Create the current user
    @user = FactoryBot.create(:test_user_couch)
  end

  test 'should get index' do
    index
    assert_not_nil @couches
  end

  test 'should not find the current user' do
    index
    assert_not_includes @couches, @user.couch
  end

  test 'should return no results if city is not found' do
    # Create at least one user with couch
    @host = FactoryBot.create(:test_user_couch)

    # Filter for a city that doesn't exist
    params[:query] = 'Nonexistent City'
    index

    # Add assertions to check that the search filter was applied correctly
    assert_equal 0, @couches.length
  end

  test 'should search by city' do
    # Create at least one couch
    @host = FactoryBot.create(:test_user_couch)

    # Filter by city
    city = @host[:city]
    params[:query] = city
    index

    # Add assertions to check that the search filter was applied correctly
    assert_equal 1, @couches.length
    assert_equal [@host.couch], @couches
  end

  test 'should search by country' do
    # Create at least one couch
    @host = FactoryBot.create(:test_user_couch, country: 'Canada')
    @host.country = 'Canada'
    @host.save!

    # Filter by country
    params[:query] = 'Canada'
    index

    # Add assertions to check that the search filter was applied correctly
    assert_equal 1, @couches.length
    assert_equal [@host.couch], @couches
  end

  test 'should apply characteristics filter' do
    # Create two couches
    @host = FactoryBot.create(:test_user_couch)
    @host2 = FactoryBot.create(:test_user_couch)

    # Create a characteristic and assign it to only one host
    characteristic1, characteristic2 = create_characteristics(2)

    @host.user_characteristics.create!(characteristic: characteristic1)
    @host2.user_characteristics.create!(characteristic: characteristic2)

    # Check that the characteristics filter is not applied when no characteristics are selected
    index
    assert_equal 2, @couches.length, 2
    assert_same_elements [@host.couch, @host2.couch], @couches

    # Set up necessary conditions for the characteristics filter
    params[:characteristics] = [characteristic2.id]
    index
    # Add assertions to check that the characteristics filter was applied correctly
    assert_equal 1, @couches.length
    assert_equal [@host2.couch], @couches
  end

  test 'should apply multiple characteristics filter' do
    # Create two couches
    @host = FactoryBot.create(:test_user_couch)
    @host2 = FactoryBot.create(:test_user_couch)

    # Create some characteristics
    characteristic1, characteristic2 = create_characteristics(2)
    @host.user_characteristics.create!(characteristic: characteristic1)
    @host.user_characteristics.create!(characteristic: characteristic2)
    @host2.user_characteristics.create!(characteristic: characteristic2)

    # Set up necessary conditions for the characteristics filter
    params[:characteristics] = [characteristic1.id, characteristic2.id]
    index
    # Add assertions to check that the characteristics filter was applied correctly
    assert_equal 1, @couches.length
    assert_equal [@host.couch], @couches
  end

  test 'should only return couches that offer hang out' do
    # Create two couches
    @host = FactoryBot.create(:test_user_couch)
    @host.offers_hang_out = true
    @host.save!

    @host2 = FactoryBot.create(:test_user_couch)
    @host2.offers_hang_out = false
    @host2.save!

    # Set up necessary conditions for the offers filter
    params[:offers_hang_out] = true
    index

    # Add assertions to check that the offers filter was applied correctly
    assert_equal 1, @couches.length
    assert_equal [@host.couch], @couches
  end

  test 'should only return couches that offer co work' do
    # Create two couches
    @host = FactoryBot.create(:test_user_couch)
    @host.offers_co_work = false
    @host.save!

    @host2 = FactoryBot.create(:test_user_couch)
    @host2.offers_co_work = false
    @host2.save!

    # Set up necessary conditions for the offers filter
    params[:offers_hang_out] = true
    index

    # Add assertions to check that the offers filter was applied correctly
    assert_equal 0, @couches.length
  end

  test 'should only return couches that offer a couch' do
    # Create two couches
    @host = FactoryBot.create(:test_user_couch)
    @host.offers_couch = true
    @host.save!

    @host2 = FactoryBot.create(:test_user_couch)
    @host2.offers_couch = false
    @host2.save!

    # Set up necessary conditions for the offers filter
    params[:offers_couch] = true
    index

    # Add assertions to check that the offers filter was applied correctly
    assert_equal 1, @couches.length
    assert_equal [@host.couch], @couches
  end

  test 'should combine offer and query filter' do
    # Create two couches
    @host = FactoryBot.create(:test_user_couch)
    @host.offers_couch = true
    @host.city = 'Test City'
    @host.save!

    @host2 = FactoryBot.create(:test_user_couch)
    @host2.offers_couch = true
    @host2.city = 'Another City'
    @host2.save!

    # Set up necessary conditions for the offers filter
    params[:offers_couch] = true
    params[:query] = 'Test City'
    index

    # Add assertions to check that the offers filter was applied correctly
    assert_equal 1, @couches.length
    assert_equal [@host.couch], @couches
  end

  test 'should combine characteristic and offer filters' do
    # Create three couches
    @host = FactoryBot.create(:test_user_couch)
    @host.offers_couch = true
    @host.save!

    @host2 = FactoryBot.create(:test_user_couch)
    @host2.offers_couch = true
    @host2.save!

    @host3 = FactoryBot.create(:test_user_couch)
    @host3.offers_couch = false
    @host3.save!

    # Add characteristic to two hosts
    characteristic = create_characteristics(1).first
    @host.user_characteristics.create!(characteristic:)
    @host2.user_characteristics.create!(characteristic:)
    @host3.user_characteristics.create!(characteristic:)

    # Set up necessary conditions for the offers filter
    params[:offers_couch] = true
    params[:characteristics] = [characteristic.id]
    index

    # Add assertions to check that the offers filter was applied correctly
    assert_equal 2, @couches.length
    assert_same_elements [@host.couch, @host2.couch], @couches
  end

  test 'should combine characteristic and query filters' do
    # Create three couches
    @host = FactoryBot.create(:test_user_couch)
    @host.city = 'Test City'
    @host.save!

    @host2 = FactoryBot.create(:test_user_couch)
    @host2.city = 'Another City'
    @host2.save!

    @host3 = FactoryBot.create(:test_user_couch)
    @host3.city = 'Test City'
    @host3.save!

    # Add characteristic to two hosts
    characteristic = create_characteristics(1).first
    @host.user_characteristics.create!(characteristic:)
    @host2.user_characteristics.create!(characteristic:)
    @host3.user_characteristics.create!(characteristic:)

    # Set up necessary conditions for the offers filter
    params[:query] = 'Test City'
    params[:characteristics] = [characteristic.id]
    index

    # Add assertions to check that the offers filter was applied correctly
    assert_equal 2, @couches.length
    assert_same_elements [@host.couch, @host3.couch], @couches
  end

  test 'should combine three different filters' do
    # Create three couches
    @host = FactoryBot.create(:test_user_couch)
    @host.offers_couch = true
    @host.city = 'Test City'
    @host.save!

    @host2 = FactoryBot.create(:test_user_couch)
    @host2.offers_couch = true
    @host2.city = 'Another City'
    @host2.save!

    @host3 = FactoryBot.create(:test_user_couch)
    @host3.offers_couch = false
    @host3.city = 'Test City'
    @host3.save!

    # Add characteristic to two hosts
    characteristic = create_characteristics(1).first
    @host.user_characteristics.create!(characteristic:)
    @host3.user_characteristics.create!(characteristic:)

    # Set up necessary conditions for the offers filter
    params[:offers_couch] = true
    params[:query] = 'Test City'
    params[:characteristics] = [characteristic.id]
    index

    # Add assertions to check that the offers filter was applied correctly
    assert_equal 1, @couches.length
    assert_equal [@host.couch], @couches
  end

  test 'pagination should work' do
    setup_with_pagination

    index

    # Add assertions to check that the offers filter was applied correctly
    assert_equal 5, @couches.length
    assert_equal 10, @pagy.count
    first_page = @couches

    # Navigate to next page
    params[:page] = 2
    index

    # Add assertions to check that the pagination works
    assert_equal 5, @couches.length
    assert_not_same @couches, first_page
  end

  test 'pagination should work with filters' do
    setup_with_pagination

    # Change the city for 5+ users
    User.last(7).each do |user|
      user.city = 'Test City'
      user.save!
    end

    assert_equal 7, User.where(city: 'Test City').count

    # Filter by city
    params[:query] = 'Test City'
    index

    # Add assertions to check that the offers filter was applied correctly
    assert_equal 5, @couches.length
    assert_equal 7, @pagy.count
    first_page = @couches

    # Navigate to next page
    params[:page] = 2
    index

    # Add assertions to check that the pagination works
    assert_equal 2, @couches.length
    assert_not_same @couches, first_page
  end

  private

  def setup_with_pagination
    # Create 10 couches
    10.times do
      FactoryBot.create(:test_user_couch)
    end

    # Set up necessary conditions for the offers filter
    params[:items] = 5
  end

  def create_characteristics(times)
    # create characteristics and return the newly created ones
    new_characteristics = []
    times.times do
      new_characteristics << Characteristic.create!(name: "Characteristic#{times}")
    end

    new_characteristics
  end

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

# frozen_string_literal: true

require 'test_helper'

class CouchesConcernTest < ActiveSupport::TestCase
  include CouchesConcern

  setup do
    # Clean up the database to avoid conflicts but create a seed user without a couch to use the invite_code
    db_cleanup
    create_seed_user

    # Create the current user
    @user = FactoryBot.create(:user, :for_test, :with_couch)
  end

  test 'should get couches' do
    find_and_filter
    assert_not_nil @couches
  end

  test 'should not find the current user' do
    find_and_filter
    assert_not_includes @couches, @user.couch
  end

  test 'should not find users with active set to false' do
    # Create a user with an inactive couch
    inactive_user = FactoryBot.create(:user, :for_test, :with_couch)
    inactive_user.couch.active = false
    inactive_user.couch.save!
    # Create one user with an active couch
    FactoryBot.create(:user, :for_test, :with_couch)

    find_and_filter

    # we know that there's only one active couch!
    assert_equal 1, @pagy.count

    assert_not_includes @couches, Couch.where(active: false)
  end

  test 'should return no results if city is not found' do
    # Create at least one user with couch
    @host = FactoryBot.create(:user, :for_test, :with_couch)

    # Filter for a city that doesn't exist
    params[:query] = 'Nonexistent City'
    find_and_filter

    # Add assertions to check that the search filter was applied correctly
    assert_equal 0, @couches.length
  end

  test 'should search by city' do
    # Create at least one couch
    @host = FactoryBot.create(:user, :for_test, :with_couch)

    # Filter by city
    city = @host[:city]
    params[:query] = city
    find_and_filter

    # Add assertions to check that the search filter was applied correctly
    assert_equal 1, @couches.length
    assert_equal [@host.couch], @couches
  end

  test 'should search by country' do
    # Create at least one couch
    @host = FactoryBot.create(:user, :for_test, :with_couch)
    @host.country_code = 'CA'
    @host.save!

    # Filter by country
    params[:query] = 'Canada'
    find_and_filter

    # Add assertions to check that the search filter was applied correctly
    assert_equal 1, @couches.length
    assert_equal [@host.couch], @couches
  end

  test 'should apply characteristics filter' do
    # Create two couches
    @host = FactoryBot.create(:user, :for_test, :with_couch)
    @host2 = FactoryBot.create(:user, :for_test, :with_couch)

    # Create a characteristic and assign it to only one host
    characteristic1, characteristic2 = create_characteristics(2)

    @host.user_characteristics.create!(characteristic: characteristic1)
    @host2.user_characteristics.create!(characteristic: characteristic2)

    # Check that the characteristics filter is not applied when no characteristics are selected
    find_and_filter
    assert_equal 2, @couches.length, 2
    assert_same_elements [@host.couch, @host2.couch], @couches

    # Set up necessary conditions for the characteristics filter
    params[:characteristics] = [characteristic2.id]
    find_and_filter
    # Add assertions to check that the characteristics filter was applied correctly
    assert_equal 1, @couches.length
    assert_equal [@host2.couch], @couches
  end

  test 'should apply multiple characteristics filter' do
    # Create two couches
    @host = FactoryBot.create(:user, :for_test, :with_couch)
    @host2 = FactoryBot.create(:user, :for_test, :with_couch)

    # Create some characteristics
    characteristic1, characteristic2 = create_characteristics(2)
    @host.user_characteristics.create!(characteristic: characteristic1)
    @host.user_characteristics.create!(characteristic: characteristic2)
    @host2.user_characteristics.create!(characteristic: characteristic2)

    # Set up necessary conditions for the characteristics filter
    params[:characteristics] = [characteristic1.id, characteristic2.id]
    find_and_filter
    # Add assertions to check that the characteristics filter was applied correctly
    assert_equal 1, @couches.length
    assert_equal [@host.couch], @couches
  end

  test 'should only return couches that offer hang out' do
    # Create two couches
    @host = FactoryBot.create(:user, :for_test, :with_couch)
    @host.offers_hang_out = true
    @host.save!

    @host2 = FactoryBot.create(:user, :for_test, :with_couch)
    @host2.offers_hang_out = false
    @host2.save!

    # Set up necessary conditions for the offers filter
    params[:offers_hang_out] = true
    find_and_filter

    # Add assertions to check that the offers filter was applied correctly
    assert_equal 1, @couches.length
    assert_equal [@host.couch], @couches
  end

  test 'should only return couches that offer co work' do
    # Create two couches
    @host = FactoryBot.create(:user, :for_test, :offers_couch)
    @host.offers_co_work = false
    @host.offers_hang_out = false
    @host.save!

    @host2 = FactoryBot.create(:user, :for_test, :offers_couch)
    @host2.offers_co_work = false
    @host2.offers_hang_out = false
    @host2.save!

    # Set up necessary conditions for the offers filter
    params[:offers_co_work] = true
    find_and_filter

    # Add assertions to check that the offers filter was applied correctly
    assert_equal 0, @couches.length
  end

  test 'should only return couches that offer a couch' do
    # Create two couches
    @host = FactoryBot.create(:user, :for_test, :offers_couch)
    @host.offers_couch = true
    @host.save!

    @host2 = FactoryBot.create(:user, :for_test, :offers_couch)
    @host2.offers_couch = false
    @host2.offers_hang_out = true
    @host2.save!

    # Set up necessary conditions for the offers filter
    params[:offers_couch] = true
    find_and_filter

    # Add assertions to check that the offers filter was applied correctly
    assert_equal 1, @couches.length
    assert_equal [@host.couch], @couches
  end

  test 'should combine offer and query filter' do
    # Create two couches
    @host = FactoryBot.create(:user, :for_test, :offers_couch)
    @host.offers_couch = true
    @host.city = 'Test City'
    @host.save!

    @host2 = FactoryBot.create(:user, :for_test, :offers_couch)
    @host2.offers_couch = true
    @host2.city = 'Another City'
    @host2.save!

    # Set up necessary conditions for the offers filter
    params[:offers_couch] = true
    params[:query] = 'Test City'
    find_and_filter

    # Add assertions to check that the offers filter was applied correctly
    assert_equal 1, @couches.length
    assert_equal [@host.couch], @couches
  end

  test 'should combine characteristic and offer filters' do
    # Create three couches
    @host = FactoryBot.create(:user, :for_test, :offers_couch)
    @host.offers_couch = true
    @host.save!

    @host2 = FactoryBot.create(:user, :for_test, :offers_couch)
    @host2.offers_couch = true
    @host2.save!

    @host3 = FactoryBot.create(:user, :for_test, :offers_couch)
    @host3.offers_couch = false
    @host3.offers_hang_out = true
    @host3.save!

    # Add characteristic to two hosts
    characteristic = create_characteristics(1).first
    @host.user_characteristics.create!(characteristic:)
    @host2.user_characteristics.create!(characteristic:)
    @host3.user_characteristics.create!(characteristic:)

    # Set up necessary conditions for the offers filter
    params[:offers_couch] = true
    params[:characteristics] = [characteristic.id]
    find_and_filter

    # Add assertions to check that the offers filter was applied correctly
    assert_equal 2, @couches.length
    assert_same_elements [@host.couch, @host2.couch], @couches
  end

  test 'should combine characteristic and query filters' do
    # Create three couches
    @host = FactoryBot.create(:user, :for_test, :with_couch)
    @host.city = 'Test City'
    @host.save!

    @host2 = FactoryBot.create(:user, :for_test, :with_couch)
    @host2.city = 'Another City'
    @host2.save!

    @host3 = FactoryBot.create(:user, :for_test, :with_couch)
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
    find_and_filter

    # Add assertions to check that the offers filter was applied correctly
    assert_equal 2, @couches.length
    assert_same_elements [@host.couch, @host3.couch], @couches
  end

  test 'should combine three different filters' do
    # Create three couches
    @host = FactoryBot.create(:user, :for_test, :offers_couch)
    @host.offers_couch = true
    @host.city = 'Test City'
    @host.save!

    @host2 = FactoryBot.create(:user, :for_test, :offers_couch)
    @host2.offers_couch = true
    @host2.city = 'Another City'
    @host2.save!

    @host3 = FactoryBot.create(:user, :for_test, :offers_couch)
    @host3.offers_couch = false
    @host3.offers_hang_out = true
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
    find_and_filter

    # Add assertions to check that the offers filter was applied correctly
    assert_equal 1, @couches.length
    assert_equal [@host.couch], @couches
  end

  test 'pagination should work' do
    setup_with_pagination

    find_and_filter

    # Add assertions to check that the offers filter was applied correctly
    assert_equal 5, @couches.length
    assert_equal 10, @pagy.count
    first_page = @couches

    # Navigate to next page
    params[:page] = 2
    find_and_filter

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
    find_and_filter

    # Add assertions to check that the offers filter was applied correctly
    assert_equal 5, @couches.length
    assert_equal 7, @pagy.count
    first_page = @couches

    # Navigate to next page
    params[:page] = 2
    find_and_filter

    # Add assertions to check that the pagination works
    assert_equal 2, @couches.length
    assert_not_same @couches, first_page
  end

  test 'should haze coordinate' do
    original_latitude = 52.516112

    # Test the haze function
    hazy_latitude = randomly_haze(original_latitude)
    assert_not_equal original_latitude, hazy_latitude

    hazy_latitude2 = randomly_haze(original_latitude)
    assert_not_equal hazy_latitude, hazy_latitude2
  end

  test 'should generate fuzzy marker for couch' do
    user = FactoryBot.create(:user, :offers_couch)

    # Stub :url_for to return a string, since we don't need to test it
    stub(:get_user_photo, '') do
      marker = couch_to_marker(user.couch)

      assert_not_nil marker
      assert_equal user.couch.id, marker[:id]
      assert_not_equal user.longitude, marker[:lng]
      assert_not_equal user.latitude, marker[:lat]
    end
  end

  private

  def setup_with_pagination
    # Create 10 couches
    10.times do
      FactoryBot.create(:user, :for_test, :with_couch)
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
end

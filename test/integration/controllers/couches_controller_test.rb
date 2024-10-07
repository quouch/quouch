require 'test_helper'

class CouchesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = FactoryBot.create(:user, :for_test, :with_couch)
    sign_in_as(@user)
  end

  test 'should get index' do
    get couches_url
    assert_response :success
  end

  test 'should apply search filter' do
    get couches_url, params: { query: 'search_term' }
    assert_response :success
    # Add assertions to check that the search filter was applied correctly
  end

  test 'should apply characteristics filter' do
    get couches_url, params: { characteristics: %w[characteristic1 characteristic2] }
    assert_response :success
    # Add assertions to check that the characteristics filter was applied correctly
  end

  test 'should apply offers filter' do
    get couches_url, params: { offers_couch: true }
    assert_response :success
    # Add assertions to check that the offers filter was applied correctly
  end

  test 'should paginate results' do
    get couches_url, params: { items: 5 }
    assert_response :success
    # Add assertions to check that the pagination works
  end

  test 'should generate markers for geocoded couches' do
    @controller = CouchesController.new

    # Create two hosts
    users = FactoryBot.create_list(:user, 2, :offers_couch, :geocoded)

    # Stub :url_for to return a string, since we don't need to test it
    @controller.stub(:url_for, '') do
      @controller.send(:generate_markers, Couch.where(user: users))

      markers = @controller.instance_variable_get(:@markers)
      assert_not_nil markers
      assert_equal 2, markers.size
      marker1 = markers[0]
      marker_couch = Couch.find(marker1[:id])
      marker_user = marker_couch.user
      assert_not_nil markers[0][:fuzzy]
      assert_includes markers[0][:fuzzy], marker_user.zipcode
      assert_equal marker_couch.id, marker1[:id]
      assert_equal marker_user.longitude, marker1[:lng]
      assert_equal marker_user.latitude, marker1[:lat]
      assert_not_nil marker1[:info_popup]
    end
  end
end

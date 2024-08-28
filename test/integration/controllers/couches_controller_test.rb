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
end

require 'test_helper'

class CouchTest < ActiveSupport::TestCase
  test 'should not save couch without a user' do
    couch = Couch.new
    assert_not couch.valid?
  end

  test 'should save couch with a user' do
    @user = FactoryBot.create(:test_user)

    couch = Couch.new(user: @user)
    assert couch.valid?
  end
end

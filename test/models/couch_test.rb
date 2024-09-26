require 'test_helper'

class CouchTest < ActiveSupport::TestCase
  setup do
    create_seed_user
    @user = FactoryBot.create(:user, :for_test)
  end

  test 'should not save couch without a user' do
    couch = Couch.new
    assert_not couch.valid?
  end

  test 'should save couch with a user' do
    couch = Couch.new(user: @user)
    assert couch.valid?
  end

  test 'should have facilities' do
    couch = Couch.create!(user: @user)

    facility = Facility.first
    couch.couch_facilities.create(facility:)

    assert couch.facilities?
  end

  test 'should not have facilities' do
    couch = Couch.create!(user: @user)

    assert_not couch.facilities?
  end

  test 'should remove facilities' do
    couch = Couch.create!(user: @user)

    facility = Facility.first
    couch.couch_facilities.create(facility:)
    couch.couch_facilities.destroy_all

    assert_not couch.facilities?
  end

  test 'should calculate rating' do
    couch = Couch.create!(user: @user)

    ratings = [5, 1, 3]
    ratings.each do |rating|
      create_review(couch:, rating:)
    end

    assert_equal 3, couch.rating
  end

  test 'should have a rating of 0 if no reviews are present' do
    couch = Couch.create!(user: @user)

    assert_equal 0, couch.rating
  end

  private

  def create_review(couch:, rating:)
    booking = FactoryBot.create(:booking, :completed)
    booking.couch = couch
    booking.save!
    Review.create!(couch:, user: booking.user, booking:, rating:, content: Faker::Hipster.paragraph)
  end
end

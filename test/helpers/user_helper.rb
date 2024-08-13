module UserHelper
  def create_user_with(email:, password:)
    @user = FactoryBot.build(:test_user, email:, password:)
    @user.save!
    Couch.create!(user: @user)
    @user
  end
end

module UserHelper
  def create_user_with(email:, password:)
    @user = FactoryBot.build(:test_user_couch, email:, password:)
    @user.save!
    @user
  end
end

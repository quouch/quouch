module UserHelper
  def create_user_with(email:, password:)
    @user = FactoryBot.build(:user, :for_test, email:, password:)
    @user.save!
    Couch.create!(user: @user)
    @user
  end

  def create_seed_user
    random_address = ADDRESSES.sample

    base_user = User.new(
      email: Faker::Internet.email,
      password: Faker::Internet.password,
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      confirmed_at: Time.now,
      address: AddressHelper.format_address(random_address),
      zipcode: random_address[:zipcode],
      city: random_address[:city],
      country: random_address[:country],
      travelling: true
    )

    base_user.save!(validate: false)
  end
end

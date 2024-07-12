class InitializeJtiForExistingUsers < ActiveRecord::Migration[7.0]
  def change
    # Since we already have user records, we will need to initialize its `jti` column before setting it to not nullable.
    change_column_null :users, :jti, true

    User.all.each { |user| user.update_column(:jti, SecureRandom.uuid) }
    change_column_null :users, :jti, false
  end
end

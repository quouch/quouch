class AddCountryCodeToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :country_code, :string

    # Copy the existing country column to the new country_code column, we will update all the records manually
    User.all.each { |user| user.update_column(:country_code, user.country) }
  end
end

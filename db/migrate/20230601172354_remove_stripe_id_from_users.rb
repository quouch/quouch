class RemoveStripeIdFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :stripe_id
  end
end

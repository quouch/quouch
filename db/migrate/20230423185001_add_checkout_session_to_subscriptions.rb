class AddCheckoutSessionToSubscriptions < ActiveRecord::Migration[7.0]
  def change
    add_column :subscriptions, :checkout_session_id, :string
  end
end

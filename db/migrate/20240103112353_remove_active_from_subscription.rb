class RemoveActiveFromSubscription < ActiveRecord::Migration[7.0]
  def change
    remove_column :subscriptions, :active
    add_column :subscriptions, :end_of_period, :date
  end
end

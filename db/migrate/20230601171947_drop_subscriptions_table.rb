class DropSubscriptionsTable < ActiveRecord::Migration[7.0]
  def change
    drop_table :subscriptions
  end
end

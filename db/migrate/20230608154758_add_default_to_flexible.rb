class AddDefaultToFlexible < ActiveRecord::Migration[7.0]
  def change
    change_column_default :bookings, :flexible, from: nil, to: false
  end
end

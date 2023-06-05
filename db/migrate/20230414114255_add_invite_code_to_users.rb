class AddInviteCodeToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :invite_code, :string
  end
end

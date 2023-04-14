class RemoveInvitationAndAuthenticationFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :invitation_token
    remove_column :users, :invitation_created_at
    remove_column :users, :invitation_sent_at
    remove_column :users, :invitation_accepted_at
    remove_column :users, :invitation_limit
    remove_column :users, :invited_by_type
    remove_column :users, :invited_by_id
    remove_column :users, :invitations_count
    remove_column :users, :authentication_token
  end
end

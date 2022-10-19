class AddColumnsToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :pronouns, :string
    add_column :users, :date_of_birth, :date
    add_column :users, :summary, :text
    add_column :users, :offers_couch, :boolean
    add_column :users, :offers_co_work, :boolean
    add_column :users, :offers_hang_out, :boolean
    add_column :users, :question_one, :text
    add_column :users, :question_two, :text
    add_column :users, :question_three, :text
    add_column :users, :question_4, :text
  end
end

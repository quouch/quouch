class ChangeContentColumnToText < ActiveRecord::Migration[7.0]
  def change
    change_column :reviews, :content, :text
  end
end

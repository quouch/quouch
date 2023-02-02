class ChangeReviewContentColumn < ActiveRecord::Migration[7.0]
  def change
    rename_column :reviews, :description, :content
  end
end

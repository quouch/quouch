class ChangeReviewContentType < ActiveRecord::Migration[7.0]
  def change
    change_column :reviews, :content, :string
  end
end

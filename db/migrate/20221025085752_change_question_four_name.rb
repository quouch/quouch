class ChangeQuestionFourName < ActiveRecord::Migration[7.0]
  def change
    rename_column :users, :question_4, :question_four
  end
end

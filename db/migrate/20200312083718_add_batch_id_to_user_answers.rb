class AddBatchIdToUserAnswers < ActiveRecord::Migration[6.0]
  def change
    add_column :user_answers, :batch_id, :integer
  end
end

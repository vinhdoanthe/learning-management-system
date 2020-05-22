class AddBatchIdToPost < ActiveRecord::Migration[6.0]
  def change
    add_column :sc_posts, :batch_id, :integer
  end
end

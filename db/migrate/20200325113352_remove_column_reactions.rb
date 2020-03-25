class RemoveColumnReactions < ActiveRecord::Migration[6.0]
  def change
  	remove_column :reactions, :user_id_id if column_exists?(:reactions, :user_id_id)
  end
end

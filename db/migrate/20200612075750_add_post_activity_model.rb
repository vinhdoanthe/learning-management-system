class AddPostActivityModel < ActiveRecord::Migration[6.0]
  def change
    create_table :post_activities do |t|
      t.integer :sc_post_id, index: true
      t.integer :activitiable_id
      t.string :activitiable_type
    end

    add_index :post_activities, [:activitiable_id, :activitiable_type]
  end
end

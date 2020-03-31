class CreateBroadcastNoti < ActiveRecord::Migration[6.0]
  def change
    create_table :broadcast_noti do |t|
      t.text :content
      t.text :title
      t.integer :created_by
      t.datetime :expiry_date

      t.timestamps
    end
  end
end

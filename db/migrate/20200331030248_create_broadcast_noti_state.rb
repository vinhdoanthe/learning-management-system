class CreateBroadcastNotiState < ActiveRecord::Migration[6.0]
  def change
    create_table :broadcast_noti_state do |t|
      t.boolean :status
      t.integer :broadcast_notice_id
      t.integer :user_id
      t.datetime :read_at

      t.timestamps
    end
  end
end

class UpdateReferFriendModel < ActiveRecord::Migration[6.0]
  def change
    add_column :refer_friends, :refer_key, :uuid
    add_column :refer_friends, :crm_lead_id, :integer, index: true
    add_column :refer_friends, :success_conversion_date, :date
    add_column :refer_friends, :conversion_value, :decimal, :precision => 20, :scale => 2
    add_column :refer_friends, :cashback_value, :decimal, :precision => 20, :scale => 2

    add_foreign_key :refer_friends, :crm_lead, column: :crm_lead_id
  end
end

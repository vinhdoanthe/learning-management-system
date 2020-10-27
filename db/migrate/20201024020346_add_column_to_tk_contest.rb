class AddColumnToTkContest < ActiveRecord::Migration[6.0]
  def change
    add_column :tk_contests, :rule_atendance_information, :string
    add_column :tk_contests, :rule_product_description, :string
    add_column :tk_contests, :rule_submission_entries, :string
  end
end

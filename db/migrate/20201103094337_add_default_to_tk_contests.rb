class AddDefaultToTkContests < ActiveRecord::Migration[6.0]
  def change
    add_column :tk_contests, :default, :boolean
  end
end

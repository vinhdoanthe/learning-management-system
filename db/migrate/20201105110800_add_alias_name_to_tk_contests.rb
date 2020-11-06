class AddAliasNameToTkContests < ActiveRecord::Migration[6.0]
  def change
    add_column :tk_contests, :alias_name, :string, unique: true
  end
end

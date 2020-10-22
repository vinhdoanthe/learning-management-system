class DropContestProject < ActiveRecord::Migration[6.0]
  def change
    drop_table('tk_contest_projects', if_exists: true)
  end
end

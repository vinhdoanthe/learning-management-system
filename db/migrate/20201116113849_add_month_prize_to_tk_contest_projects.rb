class AddMonthPrizeToTkContestProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :tk_contest_projects, :month_prize, :integer
  end
end

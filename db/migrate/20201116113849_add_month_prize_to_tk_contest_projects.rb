class AddMonthPrizeToTkContestProjects < ActiveRecord::Migration[6.0]
  def change
    unless column_exists? :tk_contest_projects, :month_prize
    add_column :tk_contest_projects, :month_prize, :integer
    end
  end
end

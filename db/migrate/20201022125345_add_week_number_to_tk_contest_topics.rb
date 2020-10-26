class AddWeekNumberToTkContestTopics < ActiveRecord::Migration[6.0]
  def change
    add_column :tk_contest_topics, :week_number, :integer
  end
end

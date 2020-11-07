class AddStartTimeToTkContestEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :tk_contest_events, :start_time, :datetime
  end
end

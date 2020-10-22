class AddStatusToTkContestTopic < ActiveRecord::Migration[6.0]
  def change
    add_column :tk_contest_topics, :status, :string
  end
end

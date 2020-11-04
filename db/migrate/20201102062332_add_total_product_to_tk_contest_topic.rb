class AddTotalProductToTkContestTopic < ActiveRecord::Migration[6.0]
  def change
    add_column :tk_contest_topics, :total_product, :integer
  end
end

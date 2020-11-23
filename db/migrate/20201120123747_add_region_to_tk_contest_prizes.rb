class AddRegionToTkContestPrizes < ActiveRecord::Migration[6.0]
  def change
    add_column :tk_contest_prizes, :region, :string
  end
end

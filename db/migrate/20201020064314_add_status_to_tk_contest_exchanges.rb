class AddStatusToTkContestExchanges < ActiveRecord::Migration[6.0]
  def change
    add_column :tk_contest_exchanges, :status, :string
  end
end

class Contest::ContestPrize < ApplicationRecord
  self.table_name = "tk_contest_prizes"

  serialize :month_active, Array
end

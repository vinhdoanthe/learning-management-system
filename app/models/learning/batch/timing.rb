class Learning::Batch::Timing < ApplicationRecord
  self.table_name = 'op_timing'
  
  has_many :gen_batch_table_lines, class_name: 'Learning::Batch::GenBatchTableLine', foreign_key: 'timing_id'
end

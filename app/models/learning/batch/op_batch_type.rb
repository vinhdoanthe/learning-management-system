module Learning
  module Batch
    class OpBatchType < ApplicationRecord
      self.table_name = 'op_batch_type'

      has_many :op_batch, foreign_key: 'type_id'
    end
  end
end
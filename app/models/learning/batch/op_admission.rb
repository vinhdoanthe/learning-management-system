module Learning
  module Batch
    class OpAdmission < ApplicationRecord
      self.table_name = 'op_admission'

      belongs_to :order, class_name: 'Sale::Order', foreign_key: :sale_order_id
      belongs_to :op_batch, foreign_key: :batch_id
    end
  end
end
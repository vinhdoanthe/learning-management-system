module Sale
  class SaleOrderLineSubjectRel < ApplicationRecord
    self.table_name = 'sale_order_line_subject_rel'
    self.primary_keys = :order_line_id, :subject_id

    belongs_to :order_line, foreign_key: :order_line_id
    belongs_to :op_subject, :class_name => 'Learning::Course::OpSubject', foreign_key: :subject_id
  end
end
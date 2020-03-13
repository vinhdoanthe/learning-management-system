module Sale
  class OrderLine < ApplicationRecord
    self.table_name = 'sale_order_line'

    belongs_to :order, foreign_key: :order_id
    has_many :sale_order_line_subject_rels, foreign_key: :order_line_id
    has_many :op_subjects, class_name: 'Learning::Course::OpSubject', through: :sale_order_line_subject_rels
  end
end
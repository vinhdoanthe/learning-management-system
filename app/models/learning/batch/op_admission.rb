module Learning
  module Batch
    class OpAdmission < ApplicationRecord
      self.table_name = 'op_admission'

      belongs_to :order, class_name: 'Sale::Order', foreign_key: :sale_order_id
      belongs_to :op_batch, foreign_key: :batch_id
      has_many :op_admission_subject_rels, class_name: 'Learning::Batch::OpAdmissionSubjectRel', foreign_key: :admission_id
      has_many :op_subjects, class_name: 'Learning::Course::OpSubject', through: :op_admission_subject_rels
    end
  end
end

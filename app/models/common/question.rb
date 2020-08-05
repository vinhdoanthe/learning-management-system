class Common::Question < ApplicationRecord
  self.table_name = 'faq_questions'

  has_one :answer, class_name: 'Common::Answer', foreign_key: 'faq_questions_id'
end

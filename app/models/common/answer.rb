class Common::Answer < ApplicationRecord
  self.table_name = 'faq_answers'

  belongs_to :question, class_name: 'Common::Question', foreign_key: 'faq_questions_id'
end

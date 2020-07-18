module Learning
  module Homework
    class UserAnswer < ApplicationRecord
      belongs_to :user_question
      belongs_to :question_choice, required: false
      belongs_to :op_faculty, class_name: 'User::OpenEducat::OpFaculty', foreign_key: 'faculty_id'

      has_many :answer_marks, class_name: 'Learning::Homework::AnswerMark', foreign_key: 'user_answer_id'
    end
  end
end

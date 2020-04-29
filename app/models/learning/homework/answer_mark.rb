module Learning
  module Homework
    class AnswerMark < ApplicationRecord
      belongs_to :user_answer
      belongs_to :user, class_name: 'User::Account::User', foreign_key: 'teacher_id'
    end
  end
end
module User
  class User < ApplicationRecord
    extend Enumerize
    include Constant

    has_secure_password

    validates :email, presence: true, uniqueness: true
    validates :username, presence: true, uniqueness: true

    has_many :refer_friends
    has_many :coin_star_transactions
    has_many :redeem_transactions
    has_many :user_notifications

    belongs_to :op_student, required: false, foreign_key: 'student_id'
    belongs_to :op_parent, required: false, foreign_key: 'parent_id'

    enumerize :account_role, in: [Constant::ADMIN, Constant::TEACHER, Constant::PARENT, Constant::STUDENT]

    def is_admin?
      if self.account_role == Constant::ADMIN
        true
      else
        false
      end
    end

    def is_teacher?
      if self.account_role == Constant::TEACHER
        true
      else
        false
      end
    end

    def is_parent?
      if self.account_role == Constant::PARENT
        true
      else
        false
      end
    end

    def is_student?
      if self.account_role == Constant::STUDENT
        true
      else
        false
      end
    end
  end
end
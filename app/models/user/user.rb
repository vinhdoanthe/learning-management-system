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

    has_one_attached :avatar

    belongs_to :op_student, required: false, foreign_key: 'student_id'
    belongs_to :op_parent, required: false, foreign_key: 'parent_id'
    belongs_to :op_faculty, required: false, foreign_key: 'faculty_id'

    belongs_to :user, required: false, class_name: 'User::User', foreign_key: 'parent_account_id'
    has_many :users, class_name: 'User::User', foreign_key: 'parent_account_id'

    enumerize :account_role, in: [Constant::ADMIN, Constant::TEACHER, Constant::PARENT, Constant::STUDENT]

    def is_admin?
      if self.nil?
        false
      else
        if self.account_role == Constant::ADMIN
          true
        else
          false
        end
      end
    end

    def is_teacher?
      if self.nil?
        false
      else
        if self.account_role == Constant::TEACHER
          true
        else
          false
        end
      end
    end

    def is_parent?
      if self.nil?
        false
      else
        if self.account_role == Constant::PARENT
          true
        else
          false
        end
      end
    end

    def is_student?
      if self.nil?
        false
      else
        if self.account_role == Constant::STUDENT
          true
        else
          false
        end
      end
    end
  end
end
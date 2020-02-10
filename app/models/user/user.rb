class User::User < ApplicationRecord
  extend Enumerize

  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true

  has_many :refer_friends
  has_many :coin_star_transactions
  has_many :redeem_transactions
  has_many :user_notifications

  belongs_to :op_student, required: false, foreign_key: 'parent_id'
  belongs_to :op_parent, required: false, foreign_key: 'student_id'

  enumerize :account_role, in: [Constant::ADMIN, Constant::TEACHER, Constant::PARENT, Constant::STUDENT]
end
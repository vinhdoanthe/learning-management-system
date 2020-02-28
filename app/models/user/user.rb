module User
  class User < ApplicationRecord
    attr_accessor :reset_token
    extend Enumerize
    include Constant

    has_secure_password

    validates :email, presence: true
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

    # Sets the password reset attributes.
    def create_reset_digest
      self.reset_token = User.new_token
      update_attribute(:reset_digest, User.digest(reset_token))
      update_attribute(:reset_sent_at, Time.zone.now)
    end

    # Sends password reset email.
    def send_password_reset_email
      UserMailer.password_reset(self).deliver_now
    end


    def User.new_token
      SecureRandom.urlsafe_base64
    end

    def User.digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                 BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    def authenticated?(attribute, token)
      digest = send("#{attribute}_digest")
      return false if digest.nil?
      BCrypt::Password.new(digest).is_password?(token)
    end

    def password_reset_expired?
      reset_sent_at < 2.days.ago
    end

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
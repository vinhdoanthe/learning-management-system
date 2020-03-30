module User
  class User < ApplicationRecord
    attr_accessor :reset_token
    extend Enumerize
    include Constant

    has_secure_password

    validates :email, presence: true
    validates :username, presence: true, uniqueness: true

    belongs_to :op_student, required: false, foreign_key: 'student_id'
    belongs_to :op_parent, required: false, foreign_key: 'parent_id'
    belongs_to :op_faculty, required: false, foreign_key: 'faculty_id'

    belongs_to :user, required: false, class_name: 'User::User', foreign_key: 'parent_account_id'

    has_many :refer_friends
    has_many :coin_star_transactions
    has_many :redeem_transactions
    has_many :user_notifications
    has_many :users, class_name: 'User::User', foreign_key: 'parent_account_id'

    has_one_attached :avatar

    enumerize :account_role, in: [Constant::ADMIN, Constant::TEACHER, Constant::PARENT, Constant::STUDENT]

    def student_name
      if student_id
        op_student = OpStudent.find(student_id)
        op_student.full_name
      else
        ''
      end
    end

    def parent_name
      if parent_id
        op_parent = OpParent.find(parent_id)
        op_parent.full_name
      else
        if student_id
          if parent_account_id
            parent_user = User.find(parent_account_id)
            if !parent_user.nil?
              parent_user.parent_name
            else
              ''
            end
          else
            ''
          end
        else
          ''
        end
      end
    end

    def faculty_name
      if faculty_id
        op_faculty = OpFaculty.find(faculty_id)
        op_faculty.full_name
      else
        ''
      end
    end

    def center_name
      company = nil
      if !student_id.nil?
        op_student = OpStudent.find(student_id)
        if !op_student.nil? && !op_student.company_id.nil?
          company = Common::ResCompany.find(op_student.company_id)
        end
      elsif !parent_id.nil?
        op_parent = OpParent.find(parent_id)
        if !op_parent.nil? && !op_parent.name.nil?
          res_partner = ResPartner.find(op_parent.name)
          if !res_partner.nil? && !res_partner.company_id.nil?
            company = Common::ResCompany.find(op_parent.company_id)
          end
        end
      elsif !faculty_id.nil?
        op_faculty = OpFaculty.find(faculty_id)
        if !op_faculty.nil? && !op_faculty.company_id.nil?
          company = Common::ResCompany.find(op_faculty.company_id)
        end
      end
      company.nil? ? '' : company.name
    end

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

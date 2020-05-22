class User::OpenEducat::OpFaculty < ApplicationRecord
  self.table_name = 'op_faculty'

  belongs_to :res_company, :class_name => 'Common::ResCompany', :foreign_key => 'company_id'
  belongs_to :res_partner, :primary_key => 'id', :foreign_key => 'partner_id'
  belongs_to :res_country, :class_name => 'Common::ResCountry', :foreign_key => 'country_id'
  belongs_to :res_user, class_name: 'Common::ResUser', foreign_key: 'related_user'

  has_one :user, class_name: 'User::Account::User', :foreign_key => 'faculty_id'

  has_many :op_sessions, :class_name => 'Learning::Batch::OpSession', :foreign_key => 'faculty_id'
  has_many :op_batches, :class_name => 'Learning::Batch::OpBatch', :through => 'op_sessions'
  has_many :user_answers, :class_name => 'Learning::Homework::UserAnswer', foreign_key: 'faculty_id'
  
  rails_admin do
    list do
      field :full_name
      field :gender
      field :vattr_email
      field :user
    end

    show do
      field :full_name
      field :gender
      field :vattr_email
      field :user
    end
  end

  def vattr_email
    if res_user.nil?
      '-'
    else
      res_user.login
    end
  end

  def self.get_avatars_by_gender(gender=nil)
    if !gender.nil?
      avatars = User::Account::Avatar.where(gender: gender).to_a
    else
      avatars = User::Account::Avatar.all.to_a
    end

    avatars
  end
end

class User::OpenEducat::OpStudent < ApplicationRecord
  self.table_name = 'op_student'

  has_many :op_parent_op_student_rels
  has_many :op_parents, through: :op_parent_op_student_rels

  has_many :op_student_courses, class_name: 'Learning::Batch::OpStudentCourse', foreign_key: 'student_id'
  has_many :op_batches, through: :op_student_courses, class_name: 'Learning::Batch::OpBatch'
  has_many :op_attendance_lines, class_name: 'Learning::Batch::OpAttendanceLine', foreign_key: 'student_id'
  has_many :op_sessions, through: :op_batches, class_name: 'Learning::Batch::OpSession'
  has_many :op_courses, through: :op_batches, class_name: 'Learning::Course::OpCourse'

  belongs_to :res_country, :class_name => 'Common::ResCountry', :primary_key => 'id', :foreign_key => 'nationality'
  belongs_to :res_company, :class_name => 'Common::ResCompany', :foreign_key => 'company_id'

  def vattr_gender
    if gender == 'm'
      'Male'
    elsif gender == 'f'
      'Female'
    else
      ''
    end
  end

  def vattr_center_name
    if company_id
      res_company = Common::ResCompany.find(company_id)
      if res_company
        res_company.name
      else
        ''
      end
    else
      ''
    end 
  end

  def vattr_parent_email
    if parent_email
      parent_email
    elsif parent_mail
      parent_mail
    else
      if parent_id
        op_parent = op_parents.last
        if op_parent
          op_parent.email
        else
          ''
        end
      else
        ''
      end
    end
  end

  def vattr_parent_full_name
    name = '' 
    if parent_id
      op_parent = op_parents.last
      if op_parent && op_parent.name
        res_partner = ResPartner.find(op_parent.name)
        if res_partner
          if res_partner.display_name
            name = res_partner.display_name
          else
            name = res_partner.name
          end
        end
      end
    end
    name
  end

  def vattr_parent_relation_type
    'Parents'
  end

  def vattr_parent_phone
    phone = '' 
    if parent_id
      op_parent = op_parents.last
      if op_parent
        if op_parent.mobile
          phone = op_parent.mobile
        else
          phone = op_parent.phone
        end
      end
    end
    phone
  end

  def vattr_parent_address
    address = '' 
    if parent_id
      op_parent = op_parents.last
      if op_parent && op_parent.name
        res_partner = ResPartner.find(op_parent.name)
        if res_partner
          if res_partner.street
            address = res_partner.street
          else
            address = res_partner.street2
          end
        end
      end
    end
    address
  end

  def vattr_parent_district
    district = '' 
    if parent_id
      op_parent = op_parents.last
      if op_parent && op_parent.name
        res_partner = ResPartner.find(op_parent.name)
        if res_partner
          if res_partner.city
            district = res_partner.city
          end
        end
      end
    end
    district
  end

  def vattr_parent_nation
    nation = '' 
    if parent_id
      op_parent = op_parents.last
      if op_parent && op_parent.name
        res_partner = ResPartner.find(op_parent.name)
        if res_partner
          if res_partner.country_id
            res_country = Common::ResCountry.find(res_partner.country_id)
            if res_country
              nation = res_country.name
            end
          end
        end
      end
    end
    nation
  end

end

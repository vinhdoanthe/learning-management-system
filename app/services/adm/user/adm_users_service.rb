class Adm::User::AdmUsersService
  def student_info user
    student = user.op_student
    return false if student.blank?

    email = student.parent_email
    company = if student.res_company.present?
                student.res_company.name
              else
                ''
              end
    name = student.full_name
    parent_user = User::Account::User.where(id: user.parent_account_id).first

    if parent_user.blank?
      { user: user, name: name, target: student, email: email, company: company, parent: nil }
    else
      parent = parent_info parent_user

      { user: user, name: name, target: student, email: email, company: company, parent: parent[:target], parent_name: parent[:name], address: parent[:adress], mobile: parent[:mobile], parent_user: parent[:user] }
    end
  end

  def parent_info user
    parent = user.op_parent
    return false if parent.blank?

    email = parent.email
    mobile = parent.mobile
    res_parent = parent.res_partner

    if res_parent.present?
      name = res_parent.name
      address = res_parent.street || res_parent.street2
      company = res_parent.res_company.present? ? res_parent.res_company.name : ''
    else
      name, address, company = '', '', ''
    end

    children = User::Account::User.where(parent_account_id: user.id).joins(:op_student).pluck(:id, 'op_student.full_name')

    { user: user, target: parent, email: email, mobile: mobile, name: name, address: address, company: company, children: children }
  end

  def teacher_info user
    teacher = user.op_faculty
    return false if teacher.blank?

    email = user.email
    mobile =''
    company = teacher.res_company.present? ? teacher.res_company.name : ''
    name = teacher.full_name

    { user: user, target: teacher, email: email, mobile: mobile, name: name, company: company }
  end

  def admin_info user
    admin = user.res_user.res_partner
    name = admin.name
    email = user.email
    company = admin.res_company.name
    mobile = admin.mobile || admin.phone

    { user: user, target: admin, email: email, mobile: mobile, name: name, company: company }
  end
end

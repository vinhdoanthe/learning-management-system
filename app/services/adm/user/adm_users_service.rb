class Adm::User::AdmUsersService
  def user_index params, user, old_params
    offset = 0
    offset = ( params[:page].to_i ) * 25 if params[:page].present?
    student_query = "(users.username ilike '%#{ params[:search] }%' OR users.email ilike '%#{ params[:search] }%' OR op_student.full_name ilike '%#{ params[:search] }%' OR partner.mobile ilike '%#{ params[:search] }%')"
    teacher_query = "(users.username ilike '%#{ params[:search] }%' OR users.email ilike '%#{ params[:search] }%' OR op_faculty.full_name ilike '%#{ params[:search] }%' OR partner.mobile ilike '%#{ params[:search] }%')"
    parent_query = "(users.username ilike '%#{ params[:search] }%' OR users.email ilike '%#{ params[:search] }%' OR partner.name ilike '%#{ params[:search] }%' OR partner.mobile ilike '%#{ params[:search] }%')"
    admin_query = "(users.username ilike '%#{ params[:search] }%' OR users.email ilike '%#{ params[:search] }%' OR partner.name ilike '%#{ params[:search] }%' OR partner.mobile ilike '%#{ params[:search] }%')"
    query = ''

    allow_companies = get_allow_user_companies user
    if params[:company].present? && (params[:company].include? 'all') == false
      query = " AND company.id IN (#{ params[:company].join(',') })"
    elsif allow_companies.present?
      query = " AND company.id IN  (#{ allow_companies.join(',') })"
    end
    
    if params[:had_login].to_i == 0
      query += " AND users.last_sign_in_at IS NULL"
    else
      query += " AND users.last_sign_in_at IS NOT NULL"
    end
    
    student_query += query
    teacher_query += query
    parent_query += query
    admin_query += query

    if params[:is_active].to_boolean
      student_sub_query = "LEFT OUTER JOIN op_student_course as sc ON (sc.student_id = users.student_id AND sc.id IS NOT NULL) LEFT OUTER JOIN res_company as company ON company.id = sc.company_id"
    else
      student_sub_query = "LEFT OUTER JOIN op_student_course as sc ON (sc.student_id = users.student_id AND sc.id IS NULL) LEFT OUTER JOIN res_company as company ON company.id = sc.company_id"
    end

    if params[:role].present?
      sql = "("
      sql += ((get_student student_query, student_sub_query) + ") UNION (") if params[:role].include? "Student"
      sql += ((get_teacher teacher_query) + ") UNION (") if params[:role].include? "Teacher"
      sql += ((get_parent parent_query) + ") UNION (") if params[:role].include? "Parent"
      sql += ((get_admin admin_query, params[:role]) + ") UNION (")  if (params[:role] & ["Admin", "Content Admin", "Operation Admin"]).present?
      sql = sql[0..-9]

    else
      sql = "( #{ get_student student_query, student_sub_query }
            )
            UNION
            ( #{ get_teacher teacher_query }
            )
            UNION
            ( #{ get_parent parent_query }
            )
            UNION
            ( #{ get_admin admin_query, ['Admin', 'Operation Admin', 'Content Admin'] }
            )"
    end

    count = ''
    if old_params.reject{ |k, _| ( k == 'page' || k == 'count' ) }  != params.reject{ |k, _| k == 'page' }
      count = ActiveRecord::Base.connection.execute(sql).count
    end

    limit = " ORDER BY user_created_at DESC  LIMIT 25 OFFSET #{ offset }"
    sql += limit
    query_users = ActiveRecord::Base.connection.execute(sql)
    users = query_users.values
    all_user = []

    users.each do |info|
      user = { id: info[0], username: info[1], email: info[2], account_role: info[3], full_name: info[4], created_at: info[5], last_sign_in_at: info[6], last_sign_out_at: info[7], company: info[8], company_id: info[9], mobile: info[10], last_sign_in: info[11], code: info[12] }
      all_user << user
    end

    { all_user: all_user, count: count }
  end

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

  def get_student query, sub_query
     "SELECT DISTINCT users.id as user_id, users.username as user_name, users.email as user_email, users.account_role as user_role, op_student.full_name as full_name, users.created_at as user_created_at, users.last_sign_in_at as last_sign_in, users.last_sign_out_at as last_sign_out, company.name as company_name, company.id as company_id, partner.mobile as mobile, users.last_sign_in_at as last_sigin, op_student.code as code
     FROM users
     INNER JOIN op_student ON (op_student.id = users.student_id AND users.account_role = 'Student')
     LEFT OUTER JOIN res_partner as partner ON partner.id = op_student.partner_id
     #{ sub_query }
     WHERE #{ query }"
  end

  def get_teacher query
     "SELECT DISTINCT users.id as user_id, users.username as user_name, users.email as user_email, users.account_role as user_role, op_faculty.full_name as full_name, users.created_at as user_created_at, users.last_sign_in_at as last_sign_in, users.last_sign_out_at as last_sign_out, company.name as company_name, company.id as company_id, partner.mobile as mobile,  users.last_sign_in_at as last_sigin, users.email as user_student_email
     FROM users
     INNER JOIN op_faculty ON (op_faculty.id = users.faculty_id AND users.account_role = 'Teacher')
     LEFT OUTER JOIN res_company as company ON company.id = op_faculty.company_id
     LEFT OUTER JOIN res_partner as partner ON partner.id = op_faculty.partner_id
     WHERE #{ query }"
  end

  def get_parent query
    "SELECT DISTINCT users.id as user_id, users.username as user_name, users.email as user_email, users.account_role as user_role, partner.name as full_name, users.created_at as user_created_at, users.last_sign_in_at as last_sign_in, users.last_sign_out_at as last_sign_out, company.name as company_name, company.id as company_id, partner.mobile as mobile, users.last_sign_in_at as last_sigin, users.email as user_student_email
    FROM users
    INNER JOIN op_parent ON (op_parent.id = users.parent_id AND users.account_role = 'Parent')
    LEFT OUTER JOIN res_partner as partner ON partner.id = op_parent.name
    LEFT OUTER JOIN res_company as company ON company.id = partner.company_id
    WHERE #{ query }"
  end

  def get_admin query, role
    "SELECT DISTINCT users.id as user_id, users.username as user_name, users.email as user_email, users.account_role as user_role, partner.name as full_name, users.created_at as user_created_at, users.last_sign_in_at as last_sign_in, users.last_sign_out_at as last_sign_out, company.name as company_name, company.id as company_id, partner.mobile as mobile, users.last_sign_in_at as last_sigin, users.email as user_student_email
    FROM users
    INNER JOIN res_partner as partner ON (partner.email = users.email AND users.account_role IN ('#{ role.join(',') }'))
    LEFT OUTER JOIN res_company as company ON company.id = partner.company_id
    WHERE #{ query }"
  end

  def get_allow_user_companies user
    if user.account_role == Constant::OPERATION_ADMIN
      user.user_companies.pluck(:company_id)
    else
      []
    end
  end
end

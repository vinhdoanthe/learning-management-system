class User::UsersService
  def create_student_user student
    
    existed_user = User::User.where(student_id: student.id).first
    if existed_user
      return { missing_email_student: nil, errors: nil }
    end

    user = User::User.new
    errors = []
    missing_email_student = {}
    if student.parent_email.blank?
      missing_email_student = [student.id, student.full_name, student.code]
    else
      username = student.parent_email[/[^@]+/]
      parent_user = User::User.where(email: student.parent_email, account_role: User::Constant::PARENT).first
      parent_user = create_parent_user student.op_parents[0] if parent_user.blank?
      user.parent_account_id = parent_user.id
      user.password = '123456'

      old_user = User::User.where('username ILIKE ?', username).order(created_at: :DESC).first  
     
      if old_user.present?
        number_account = (old_user.username[/(\d+)(?!.*\d)/].to_i + 1).to_s
        if number_account == '1'
          username = old_user.username + number_account
        else
          username = old_user.username.gsub(/(\d+)(?!.*\d)/, number_account)
        end
      end
      
      user.username = username
      user.email = parent_user.email
      user.account_role = User::Constant::STUDENT
      user.student_id = student.id
      user.save  
    end

    { missing_email_student: missing_email_student, errors: errors }
  rescue StandardError => e
    { missing_email_student: missing_email_student, errors: e }
  end

  def create_parent_user parent
    existed_parent = User::User.where(parent_id: parent.id).first
    if existed_parent
      return existed_parent
    end

    parent_user = User::User.new
    parent_user.username = parent.email[/[^@]+/]
    # parent_user.password = parent.mobile ? parent.mobile : '12345678'
    parent_user.password = '12345678'
    parent_user.account_role = User::Constant::PARENT
    parent_user.email = parent.email
    parent_user.parent_id = parent.id
    parent_user.save
    parent_user
  end

  def create_teacher_user teacher
    existed_teacher = User::User.where(faculty_id: teacher.id).first
    return if existed_teacher

    teacher_user = User::User.new
    res_user = teacher.res_user
    return if res_user.blank?
    teacher_user.username = res_user.login[/[^@]+/]
    
    return if User::User.where(username: teacher_user.username).first.present?
    teacher_user.password = '123456'
    teacher_user.account_role = User::Constant::TEACHER
    teacher_user.faculty_id = teacher.id
    teacher_user.email = res_user.login
    teacher_user.save
  end
end

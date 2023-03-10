class User::Account::UsersService
  def create_student_user student
    existed_user = User::Account::User.where(student_id: student.id).first
    if existed_user
      return { missing_email_student: nil, errors: nil }
    end

    user = User::Account::User.new
    errors = []
    missing_email_student = {}
    if student.parent_email.blank?
      missing_email_student = [student.id, student.full_name, student.code]
      username = student.full_name.mb_chars.unicode_normalize(:nfkd).gsub(/[^\x00-\x7F]/n,'').gsub(/\s+/, "").downcase.to_s
      user.email = '-'
    else
      username = student.parent_email[/[^@]+/].strip
      # parent_user = User::Account::User.where(email: student.parent_email, account_role: User::Constant::PARENT).first
      # parent_user = create_parent_user student.op_parents[0] if parent_user.blank?
      user.email = student.parent_email
      # user.parent_account_id = parent_user.id
    end

    password = (0..8).map { (65 + rand(26)).chr }.join
    user.initial_password = password 
    user.password = password 

    old_user = User::Account::User.where('username ILIKE ?', username).order(created_at: :DESC).first
    while !old_user.nil?
      if old_user.present?
        number_account = (old_user.username[/(\d+)(?!.*\d)/].to_i + 1).to_s
        if number_account == '1'
          username = old_user.username + number_account
        else
          username = old_user.username.gsub(/(\d+)(?!.*\d)/, number_account)
        end
      end
      old_user = User::Account::User.where('username ILIKE ?', username).order(created_at: :DESC).first
    end

    user.username = username
    user.account_role = User::Constant::STUDENT
    user.student_id = student.id
    user.save  

    { missing_email_student: missing_email_student, errors: errors }
  rescue StandardError => e
    { missing_email_student: missing_email_student, errors: e }
  end

  def create_parent_user parent
    existed_parent = User::Account::User.where(parent_id: parent.id).first
    if existed_parent
      return existed_parent
    end

    parent_user = User::Account::User.new
    parent_user.username = parent.email[/[^@]+/]
    # parent_user.password = parent.mobile ? parent.mobile : '12345678'
    password = (0..8).map { (65 + rand(26)).chr }.join
    parent_user.initial_password = password
    parent_user.password = password
    parent_user.account_role = User::Constant::PARENT
    parent_user.email = parent.email
    parent_user.parent_id = parent.id
    parent_user.save
    parent_user
  end

  def create_teacher_user teacher
    existed_teacher = User::Account::User.where(faculty_id: teacher.id).first
    return if existed_teacher

    teacher_user = User::Account::User.new
    res_user = teacher.res_user
    return if res_user.blank?
    teacher_user.username = res_user.login[/[^@]+/]

    return if User::Account::User.where(username: teacher_user.username).first.present?
    teacher_user.password = '123456'
    teacher_user.account_role = User::Constant::TEACHER
    teacher_user.faculty_id = teacher.id
    teacher_user.email = res_user.login
    teacher_user.save
  end
  
  def self.create_faculty_user teacher
    existed_teacher = User::Account::User.where(faculty_id: teacher.id).first
    return if existed_teacher
    
    username = "gv#{teacher.id}"
    puts username
    teacher_user = User::Account::User.new
    return if User::Account::User.where(username: username).first.present?
    
    teacher_user.username = username
    teacher_user.password = Settings.user.faculty[:default_password]
    teacher_user.account_role = User::Constant::TEACHER
    teacher_user.faculty_id = teacher.id
    res_user = teacher.res_user
    return if res_user.blank?
    teacher_user.email = res_user.login
    if teacher_user.save
      SendGridMailer.new.send_email(EmailConstants::MailType::SEND_FACULTY_ACCOUNT_INFORMATION, teacher_user)
    else
    end
  end

  def update_user_avatar user, avatar
    return { type: "danger", message: "#{ I18n.t 'notice.no_avatar'}" } if avatar.blank?
    if user.avatar.present?
      if user.avatar.thumbnail.attach(avatar)
        result = { type: 'success', message: "#{ I18n.t 'notice.update_success' }" }
      else
        result = { type: 'danger', message: "#{ I18n.t 'notice.update_fail' }" }
      end
    else
      user_avatar = create_user_avatar user
      if user_avatar.thumbnail.attach(avatar)
        result = { type: 'success', message: "#{ I18n.t 'notice.update_success' }" }
      else
        result = { type: 'danger', message: "#{ I18n.t 'notice.update_fail' }" }
      end
    end

    result
  end

  def create_user_avatar user
    avatar = User::Account::Avatar.create
    user.avatar = avatar
    user.save

    avatar
  end

end

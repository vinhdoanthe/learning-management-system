class User::UsersService
  def create_student_user student
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
      user.save  
    end

    { missing_email_student: missing_email_student, errors: errors }
  rescue StandardError => e
    { missing_email_student: missing_email_student, errors: e }
  end

  def create_parent_user parent
    parent_user = User::User.new
    parent_user.username = parent.email[/[^@]+/]
    parent_user.password = parent.mobile ? parent.mobile : '12345678'
    parent_user.account_role = User::Constant::PARENT
    parent_user.email = parent.email
    parent_user.save
    parent_user
  end
end

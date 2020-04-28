namespace :export do
  require 'axlsx'
  desc 'Export all students information'
  task :op_students, [] => :environment do |t, arg|
    @op_students = User::OpenEducat::OpStudent.order(:create_date => :desc)
    op_students_export = []

    total_student = @op_students.length()
    index = 0
    @op_students.each do |op_student|
      op_student_export = []
      index = index + 1
      puts "#{index}/#{total_student}"
      op_student_export.append op_student.full_name
      op_student_export.append op_student.code
      user = User::Account::User.where(student_id: op_student.id).first
      if user.nil?
        op_student_export.append '-'
      else
        op_student_export.append user.username
      end
      op_student_export.append op_student.vattr_gender
      op_student_export.append op_student.birth_date 
      op_student_export.append op_student.nationality
      op_student_export.append op_student.vattr_center_name
      op_student_export.append op_student.vattr_parent_full_name
      op_student_export.append op_student.vattr_parent_relation_type
      op_student_export.append op_student.vattr_parent_email
      op_student_export.append op_student.vattr_parent_phone
      op_student_export.append op_student.vattr_parent_address
      op_student_export.append op_student.vattr_parent_district
      op_student_export.append op_student.vattr_parent_nation
      op_student_export.append op_student.create_date.strftime('%d-%m-%Y')

      op_students_export.append op_student_export
    end

    puts "Starting export"
    p = Axlsx::Package.new
    wb = p.workbook
    wb.add_worksheet(:name => "Students") do |sheet|
      sheet.add_row ["STT", "Ten HS", "Ma HS", "LMS Username", "Gioi Tinh", "Ngay Sinh", "Quoc Tich", "Trung Tam", "Ten Phu Huynh", "Vai Tro", "Email PH", "SDT PH", "Dia Chi PH", "Tinh/Thanh Pho", "Quoc Gia", "Ngay Tao"]
      index = 0
      op_students_export.each do |op_student_export|
        index = index + 1
        op_student_export.unshift(index)
        sheet.add_row op_student_export
      end
    end
    current_time_str = Time.now.strftime('%Y-%m-%d_%H-%M-%S')
    file_name = "data_export/students_#{current_time_str}.xlsx"
    p.serialize(file_name)
    puts "Done!"
  end

  desc 'Export all missing information students'
  task :op_student_missing_information, [] => :environment do |t,args|

    @op_students = User::OpenEducat::OpStudent.order(:create_date => :desc)
    op_students_export = []

    total_student = @op_students.length()
    index = 0
    @op_students.each do |op_student|
      op_student_export = []
      index = index + 1
      missing_fields = ''
      puts "#{index}/#{total_student}"

      op_student_export.append op_student.full_name
      op_student_export.append op_student.code
      op_student_export.append op_student.vattr_center_name
      if op_student.vattr_gender.blank?
        missing_fields = "#{missing_fields}, Gender"
      end
      if op_student.birth_date.blank?
        missing_fields = "#{missing_fields}, Birth Date"
      end
      if op_student.vattr_parent_full_name.blank?
        missing_fields = "#{missing_fields}, Parent Name"
      end
      if op_student.vattr_parent_email.blank?
        missing_fields = "#{missing_fields}, Parent Email"
      end
      if op_student.vattr_parent_phone.blank?
        missing_fields = "#{missing_fields}, Parent Phone"
      end
      if op_student.vattr_parent_address.blank?
        missing_fields = "#{missing_fields}, Parent Address"
      end
      if op_student.vattr_parent_district.blank?
        missing_fields = "#{missing_fields}, Parent City"
      end
      if op_student.vattr_parent_nation.blank?
        missing_fields = "#{missing_fields}, Parent Nation"
      end
      op_student_export.append missing_fields
      op_student_export.append op_student.create_date.strftime('%d-%m-%Y')

      op_students_export.append op_student_export
    end

    puts "Starting export"
    p = Axlsx::Package.new
    wb = p.workbook
    wb.add_worksheet(:name => "Students") do |sheet|
      sheet.add_row ["STT","Hoc Vien", "Ten HS", "Ma HS", "Thong Tin Thieu", "Ngay Tao"]
      index = 0
      op_students_export.each do |op_student_export|
        index = index + 1
        op_student_export.unshift(index)
        sheet.add_row op_student_export
      end
    end
    current_time_str = Time.now.strftime('%Y-%m-%d_%H-%M-%S')
    file_name = "data_export/missing_information_students_#{current_time_str}.xlsx"
    p.serialize(file_name)
    puts "Done!"

  end

  desc 'Export Users'
  task :export_users, [] => :environment do |t, args|
    users = User::Account::User.all
    users_export = []
    total_user = users.length()
    index = 0
    users.each do |user|
      next if !(user.account_role == User::Constant::STUDENT or user.account_role == User::Constant::TEACHER)
      user_export = []
      index = index + 1

      puts "#{index}/#{total_user}" 
      user_export << user.username
      user_export << user.account_role
      if user.account_role == User::Constant::STUDENT
        op_student = user.op_student
        if !op_student.nil?
          user_export << op_student.op_batches.count
          user_export << op_student.create_date
        else
          user_export << '-'
          user_export << '-'
        end
      else
        op_faculty = user.op_faculty
        if !op_faculty.nil?
          user_export << op_faculty.op_batches.count
          user_export << op_faculty.create_date
        else
          user_export << '-'
          user_export << '-'
        end
      end
      users_export << user_export
      puts 'done'
    end
    puts "Starting export"
    p = Axlsx::Package.new
    wb = p.workbook
    wb.add_worksheet(:name => "Acounts") do |sheet|
      sheet.add_row ["STT","Username", "Role", "Batch Count", "Created Date"]
      index = 0
      users_export.each do |user_export|
        index = index + 1
        user_export.unshift(index)
        sheet.add_row user_export
      end
    end
    current_time_str = Time.now.strftime('%Y-%m-%d_%H-%M-%S')
    file_name = "data_export/users_#{current_time_str}.xlsx"
    p.serialize(file_name)
    puts "Done!"
  end

  desc 'Export Students by Company'
  task :export_op_student_course_by_company_of_batch, [:company_id] => :environment do |t, args|
    company_id = args[:company_id].to_i
    return if !company_id
    res_company = Common::ResCompany.where(id: company_id).first
    return if res_company.nil?

    op_batch_ids = Learning::Batch::OpBatch.where(company_id: res_company.id).pluck(:id).compact
    op_student_course_ids = Learning::Batch::OpStudentCourse.where(batch_id: op_batch_ids).pluck(:id).compact
    total_op = op_student_course_ids.length()
    count_op = 0
    op_student_course = nil
    export_rows = []
    op_student_course_ids.each do |op_student_course_id|
      export_row = []
      count_op += 1
      puts "#{count_op}/#{total_op}"
      op_student_course = Learning::Batch::OpStudentCourse.where(id: op_student_course_id).first
      next if op_student_course.nil?
      op_student = op_student_course.op_student
      next if op_student.nil?
      export_row << op_student.vattr_center_name
      export_row << op_student.code
      export_row << op_student.full_name
      export_row << op_student.birth_date

      op_course = op_student_course.op_course
      if op_course.nil?
        export_row << '-'
      else
        export_row << op_course.name
      end

      op_batch = op_student_course.op_batch
      if op_batch.nil?
        export_row << '-'
      else
        export_row << op_batch.code
      end

      subject_ids = Learning::Batch::OpStudentSubject.where(student_course_id: op_student_course.id).pluck(:subject_id).uniq.compact
      subject_levels = Learning::Course::OpSubject.where(id: subject_ids).pluck(:level).uniq.compact.join(', ') 

      export_row << subject_levels

      # Admission, SO
      admission = ""
      so = ""
      op_admissions = Learning::Batch::OpAdmission.where(batch_id: op_student_course.batch_id, student_id: op_student_course.student_id).to_a
      unless op_admissions.blank?
        op_admissions.each do |op_admission|
          admission = admission + " " + op_admission.application_number.to_s
          sale_order = op_admission.order
          unless sale_order.nil?
            so = so + " " + sale_order.name
          end
        end  
      end
      export_row << admission
      export_row << so
      export_rows << export_row
    end

    puts "Starting export"
    p = Axlsx::Package.new
    wb = p.workbook
    wb.add_worksheet(:name => "Students") do |sheet|
      sheet.add_row ["STT","Company", "Code", "Name", "Birth Date", "Course", "Batch", "Subject", "Admission", "SO"]
      index = 0
      export_rows.each do |export_row|
        index = index + 1
        export_row.unshift(index)
        sheet.add_row export_row
      end
    end
    current_time_str = Time.now.strftime('%Y-%m-%d_%H-%M-%S')
    file_name = "data_export/op_student_courses_#{current_time_str}.xlsx"
    p.serialize(file_name)
    puts "Done!"
  end

  desc 'Export and Create Students by Company with Username'
  task :export_op_student_course_user_by_company_of_batch, [:company_id] => :environment do |t, args|
    company_id = args[:company_id].to_i
    return if !company_id
    res_company = Common::ResCompany.where(id: company_id).first
    return if res_company.nil?

    op_batch_ids = Learning::Batch::OpBatch.where(company_id: res_company.id).pluck(:id).compact
    op_student_course_ids = Learning::Batch::OpStudentCourse.where(batch_id: op_batch_ids).pluck(:id).compact
    total_op = op_student_course_ids.length()
    count_op = 0
    op_student_course = nil
    export_rows = []
    op_student_course_ids.each do |op_student_course_id|
      export_row = []
      count_op += 1
      puts "#{count_op}/#{total_op}"
      op_student_course = Learning::Batch::OpStudentCourse.where(id: op_student_course_id).first
      next if op_student_course.nil?
      op_student = op_student_course.op_student
      next if op_student.nil?
      export_row << op_student.vattr_center_name
      export_row << op_student.code
      export_row << op_student.full_name
      user = User::Account::User.where(student_id: op_student.id).first
      if user.nil?
        export_row << '-'
      else
        export_row << user.username
      end
      export_row << op_student.birth_date

      op_course = op_student_course.op_course
      if op_course.nil?
        export_row << '-'
      else
        export_row << op_course.name
      end

      op_batch = op_student_course.op_batch
      if op_batch.nil?
        export_row << '-'
      else
        export_row << op_batch.code
      end

      subject_ids = Learning::Batch::OpStudentSubject.where(student_course_id: op_student_course.id).pluck(:subject_id).uniq.compact
      subject_levels = Learning::Course::OpSubject.where(id: subject_ids).pluck(:level).uniq.compact.join(', ') 

      export_row << subject_levels

      # Admission, SO
      admission = ""
      so = ""
      op_admissions = Learning::Batch::OpAdmission.where(batch_id: op_student_course.batch_id, student_id: op_student_course.student_id).to_a
      unless op_admissions.blank?
        op_admissions.each do |op_admission|
          admission = admission + " " + op_admission.application_number.to_s
          sale_order = op_admission.order
          unless sale_order.nil?
            so = so + " " + sale_order.name
          end
        end  
      end
      export_row << admission
      export_row << so
      export_rows << export_row
    end

    puts "Starting export"
    p = Axlsx::Package.new
    wb = p.workbook
    wb.add_worksheet(:name => "Students") do |sheet|
      sheet.add_row ["STT","Company", "Code", "Name","LMS Username", "Birth Date", "Course", "Batch", "Subject", "Admission", "SO"]
      index = 0
      export_rows.each do |export_row|
        index = index + 1
        export_row.unshift(index)
        sheet.add_row export_row
      end
    end
    current_time_str = Time.now.strftime('%Y-%m-%d_%H-%M-%S')
    file_name = "data_export/op_student_courses_with_username_#{current_time_str}.xlsx"
    p.serialize(file_name)
    puts "Done!"
  end
  
  desc 'Export Students by Batch Code'
  task :export_op_student_course_by_batch_code, [:batch_code] => :environment do |t, args|
    batch_code = args[:batch_code].to_s
    return if batch_code.blank?

    op_batch_ids = Learning::Batch::OpBatch.where('code ilike ?', batch_code).pluck(:id).compact
    op_student_course_ids = Learning::Batch::OpStudentCourse.where(batch_id: op_batch_ids).order(batch_id: :ASC).pluck(:id).compact
    total_op = op_student_course_ids.length()
    count_op = 0
    op_student_course = nil
    export_rows = []
    op_student_course_ids.each do |op_student_course_id|
      export_row = []
      count_op += 1
      puts "#{count_op}/#{total_op}"
      op_student_course = Learning::Batch::OpStudentCourse.where(id: op_student_course_id).first
      next if op_student_course.nil?
      op_student = op_student_course.op_student
      next if op_student.nil?
      export_row << op_student.code
      export_row << op_student.full_name
      export_row << op_student.birth_date
      export_row << op_student.vattr_gender

      op_course = op_student_course.op_course
      if op_course.nil?
        export_row << '-'
      else
        export_row << op_course.name
      end
      
      op_batch = op_student_course.op_batch
      if op_batch.nil?
        export_row << '-'
      else
        export_row << op_batch.code
      end

      subject_ids = Learning::Batch::OpStudentSubject.where(student_course_id: op_student_course.id).pluck(:subject_id).uniq.compact
      subject_levels = Learning::Course::OpSubject.where(id: subject_ids).pluck(:level).uniq.compact.join(', ') 

      export_row << subject_levels

      # Admission, SO
      admission = ""
      so = ""
      op_admissions = Learning::Batch::OpAdmission.where(batch_id: op_student_course.batch_id, student_id: op_student_course.student_id).to_a
      unless op_admissions.blank?
        op_admissions.each do |op_admission|
          admission = admission + " " + op_admission.application_number.to_s
          sale_order = op_admission.order
          unless sale_order.nil?
            so = so + " " + sale_order.name
          end
        end  
      end
      export_row << admission
      export_row << so
      
      export_row << op_student.vattr_parent_full_name
      export_row << op_student.vattr_parent_email
      export_row << op_student.vattr_parent_phone

      export_row << op_student.vattr_center_name

      export_rows << export_row
    end

    puts "Starting export"
    p = Axlsx::Package.new
    wb = p.workbook
    wb.add_worksheet(:name => "Students") do |sheet|
      sheet.add_row ["STT", "Code", "Name", "Birth Date","Gender", "Course", "Batch", "Subject", "Admission", "SO", "Parent", "Email", "Mobile", "Company"]
      index = 0
      export_rows.each do |export_row|
        index = index + 1
        export_row.unshift(index)
        sheet.add_row export_row
      end
    end
    current_time_str = Time.now.strftime('%Y-%m-%d_%H-%M-%S')
    file_name = "data_export/op_student_courses_by_batch_code_#{current_time_str}.xlsx"
    p.serialize(file_name)
    puts "Done!"
  end
end

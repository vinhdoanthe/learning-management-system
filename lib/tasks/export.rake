namespace :export do
  require 'axlsx'
  desc 'Export all students information'
  task :op_students, [] => :environment do |t, arg|
    @op_students = User::OpStudent.order(:create_date => :desc)
    op_students_export = []

    total_student = @op_students.length()
    index = 0
    @op_students.each do |op_student|
      op_student_export = []
      index = index + 1
      puts "#{index}/#{total_student}"
      op_student_export.append op_student.full_name
      op_student_export.append op_student.code
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
      sheet.add_row ["STT", "Ten HS", "Ma HS","Gioi Tinh", "Ngay Sinh", "Quoc Tich", "Trung Tam", "Ten Phu Huynh", "Vai Tro", "Email PH", "SDT PH", "Dia Chi PH", "Tinh/Thanh Pho", "Quoc Gia", "Ngay Tao"]
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

    @op_students = User::OpStudent.order(:create_date => :desc)
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
end

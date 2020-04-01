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
    file_name = 'data_export/students.xlsx'
    p.serialize(file_name)
    puts "Done!"
  end
end

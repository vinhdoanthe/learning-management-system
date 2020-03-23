require 'spreadsheet'

namespace :update_lesson_learning_material do
  desc 'Create Learning Material for lesson'
  task :create_material, [:file, :course_id] => :environment do |t, args|
    course_id = args[:course_id]
    file = args[:file]
    
    course = Learning::Course::OpCourse.find(course_id)
    learning_info = Spreadsheet.open file
    learning_detail = learning_info.worksheet 0

    learning_detail.each_with_index do |row, index|
      next if index == 0
      next if row[2].blank?

      subject_level = last_number_regex row[0]
      lesson_number = first_number_regex row[1]

      subject = course.op_subjects.where(level: subject_level).first
      next if subject.nil?

      lesson = subject.op_lessions.where(lession_number: lesson_number).first
      next if lesson.nil?

      title = "Slide #{lesson.name} - #{subject.name}"
      create_learning_material lesson.id, title, row[2]
    end
  end

  def first_number_regex name
    name[/\d+/].to_i
  end

  def last_number_regex name
    name[/(\d+)(?!.*\d)/].to_i
  end

  def create_learning_material lesson_id, title, google_drive_link
    material = Learning::Material::LearningMaterial.new
    material.title = title
    material.description = title
    material.op_lession_id = lesson_id
    material.google_drive_link = google_drive_link
    material.material_type = Learning::Constant::Material::MATERIAL_TYPE_FILE
    material.learning_type = Learning::Constant::Material::MATERIAL_TYPE_TEACH
    material.save
  end

end

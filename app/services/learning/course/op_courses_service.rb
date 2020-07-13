class Learning::Course::OpCoursesService
  def initialize(course_id)
    @course = Learning::Course::OpCourse.where(id: course_id).first
  end

  def get_next_lesson lesson_id
    return nil if @course.nil?
    subject_ids = @course.op_subjects.order(:level => :ASC).pluck(:id)
    lesson_ids = []
    subject_ids.each do |subject_id|
      lesson_ids.concat Learning::Course::OpLession.where(subject_id: subject_id).order(:lession_number => :ASC).pluck(:id)
    end
    c_index = lesson_ids.find_index(lesson_id)
    return nil if (c_index.nil? or c_index == lesson_ids.count)
    next_lesson_id = lesson_ids[c_index + 1]
    Learning::Course::OpLession.where(id: next_lesson_id).first
  end

  # Lay param form
  def self.form_paramater(param_form, request)
      
      # Khoi tao cac gia tri ban dau
      course_name = course_code = ''
      page        = !param_form[:page].nil? ? param_form[:page] : 1 ;
      
      #if request.method == 'POST'
      if (!param_form[:frm].nil?)        
        course_name = param_form[:frm][:course_name].to_s
        course_code = param_form[:frm][:course_code].to_s
      end
      
      return {
        'course_name': course_name ,
        'course_code': course_code,
        'page': page
      }
  end

  # Get list course
  def self.get_courses(course_name, course_code)
    courses = Learning::Course::OpCourse.select("code, name, section").order("section")
  end
end

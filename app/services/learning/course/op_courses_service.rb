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
    keywords = ''
    page        = !param_form[:page].nil? ? param_form[:page] : 1 ;

    #if request.method == 'POST'
    if (!param_form[:filters_course].nil?)        
      keywords = param_form[:filters_course][:keywords].to_s.strip
    end

    return {
      'keywords': keywords,
      'page': page
    }
  end

  # Get list course
  def self.get_courses(keywords)

    if keywords.empty?
      courses = Learning::Course::OpCourse
        .joins('INNER JOIN op_subject ON op_subject.course_id=op_course.id')
        .joins('INNER JOIN res_users ON res_users.id = op_course.write_uid')
        .select("op_course.id as course_id,op_course.code, op_course.name, op_course.section, op_course.active, count(op_subject.id) as number_subject, op_course.write_date as update_at, res_users.login as user_name")
        .group('op_course.id, res_users.login')
        .order("op_course.write_date, op_course.section")
    else
      courses = Learning::Course::OpCourse
        .joins('INNER JOIN op_subject ON op_subject.course_id=op_course.id')
        .joins('INNER JOIN res_users ON res_users.id = op_course.write_uid')
        .select("op_course.id as course_id,op_course.code, op_course.name, op_course.section, op_course.active, count(op_subject.id) as number_subject, op_course.write_date as update_at, res_users.login as user_name")
        .where("op_course.name like '%#{keywords}%' OR op_course.code like '%#{keywords}%'")
        .group('op_course.id, res_users.login')
        .order("op_course.write_date, op_course.section")
      courses
    end

  end

  # get all lession of courses
  def self.get_all_lession_of_course(course_id)

    return Learning::Course::OpLession
      .joins('INNER JOIN op_subject ON op_subject.id = op_lession.subject_id')
      .joins('INNER JOIN op_course_op_subject_rel ON op_course_op_subject_rel.op_subject_id  = op_subject.id')
      .select("op_lession.id, op_lession.code, op_lession.name, op_lession.note, op_lession.lession_number, op_lession.subject_id, op_lession.write_date AS update_at")
      .where("op_course_op_subject_rel.op_course_id = #{course_id}")
      .order("op_subject.level, op_lession.lession_number")
  end

  def self.get_public_courses student_id
    # hard code course ids
    course_ids = Utility::PublicCourse.pluck(:course_id).uniq.compact
    courses = Learning::Course::OpCourse.where(id: course_ids, active: true).select(:id, :name, :short_description, :suitable_age, :duration)
    subjects = Learning::Course::OpSubject.where(course_id: course_ids, active: true).select(:name, :level, :total_session)
    public_courses = []
    courses.each do |course| 
      subjects = []
      course_subjects = subjects.filter {|subject| subject.course_id == course.id}
      course_subjects.each do |course_subject|
        active, percentage = Learning::Batch::OpBatchService.caculate_complete_percentage(student_id, course.id, course_subject.id)
        subject = {
          :info => {
            :name => course_subject.name,
            :thumbnail => nil,
            :complete_percentage => percentage 
          },
          :active => active
        }
        subjects << subject
      end
      public_course = {
        :name => course.name,
        :subjects => subjects,
        :short_description => course.short_description,
        :suitable_age => course.suitable_age,
        :duration => course.duration,
        :images => []
      }
      public_courses << public_course
    end
    public_courses
  end

  def self.get_public_course_detail course_id = nil, subject_id = nil, student_id = nil
    return nil if course_id.nil? || student_id.nil?
    course = Learning::Course::OpCourse.where(id: course_id).first
    
    return nil if course.nil?
    if subject_id.nil?
      subject = course.op_subjects.first 
    else
      subject = Learning::Course::OpSubject.where(id: subject_id).first
    end
    if course.nil? or subject.nil?
      return nil
    end

    if course.thumbnail.attached?
      thumbnail = course.thumbnail
    else
      thumbnail = nil
    end
    r_lessons = []
    lessons = Learning::Course::OpLession.where(subject_id: subject_id).select(:id, :name).uniq.compact

    lesson_ids = lessons.map {|lesson| lesson.id}
    videos = Learning::Material::LearningMaterial.where(op_lession_id: lesson_ids,
                                                        material_type: Learning::Constant::Material::MATERIAL_TYPE_VIDEO,
                                                        learning_type: Learning::Constant::Material::MATERIAL_TYPE_REVIEW).to_a
    lessons.each do |lesson|
      video = videos.find{|video| video.op_lession_id == lesson.id}
      thumbnail = nil
      if !video.nil? && video.thumbnail_image.attached?
        thumbnail = video.thumbnail_image
      end
      active, session_id = Learning::Batch::OpBatchService.get_session_and_active_state(course_id, subject_id, student_id, lesson.id)
      r_lesson = {
        :info => {
          :video_id => video.id,
          :thumbnail => thumbnail, 
          :name => lesson.name
        },
        :active => active,
        :session_id => session_id
      }
      r_lessons << r_lesson
    end

    course_description = course.course_description.first
    course_subject_detail = {
      :course_name => course.name,
      :subject_name => subject.name,
      :course_description => (course_description.nil? ? '' : course_description.description),
      :course_thumbnail => thumbnail,
      :active_subject => subject.id,
      :lessons => r_lessons
    } 
    course_subject_detail
  end
end

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
  def self.form_parameter(param_form, request)

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
        .select("op_course.id as course_id,op_course.code, op_course.name, op_course.section, op_course.active, count(op_subject.id) as number_subject, op_course.write_date as update_at, res_users.login as user_name, op_course.suitable_age, op_course.duration, op_course.prerequisites, op_course.equipments")
        .group('op_course.id, res_users.login')
        .order("op_course.id, op_course.write_date DESC, op_course.section")
        .includes(thumbnail_attachment: :blob)
    else
      courses = Learning::Course::OpCourse
        .joins('INNER JOIN op_subject ON op_subject.course_id=op_course.id')
        .joins('INNER JOIN res_users ON res_users.id = op_course.write_uid')
        .select("op_course.id as course_id,op_course.code, op_course.name, op_course.section, op_course.active, count(op_subject.id) as number_subject, op_course.write_date as update_at, res_users.login as user_name, op_course.suitable_age, op_course.duration, op_course.prerequisites, op_course.equipments")
        .where("op_course.name like '%#{keywords}%' OR op_course.code like '%#{keywords}%'")
        .group('op_course.id, res_users.login')
        .order("op_course.id, op_course.write_date DESC, op_course.section")
        .includes(thumbnail_attachment: :blob)
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
    p_course_ids = Utility::PublicCourse.order(:order_in_list => :ASC).pluck(:order_in_list, :course_id).uniq.compact
    values = []
    p_course_ids.each do |p_course_id|
      values << "(#{p_course_id[0].to_i}, #{p_course_id[1]})"
    end
    courses_relation = Learning::Course::OpCourse.joins("JOIN (VALUES #{values.join(",")}) as x (order_in_list, course_id) on #{Learning::Course::OpCourse.table_name}.id = x.course_id")
    courses_relation = courses_relation.order('x.order_in_list')
    courses = courses_relation.select(:id, :name, :short_description, :suitable_age, :duration)
    course_ids = courses.map{|course| course.id}
    subjects = Learning::Course::OpSubject.where(course_id: course_ids, active: true).order(level: :ASC).select(:name, :level, :total_session, :course_id, :id)
    public_courses = []

    courses.each do |course| 
      result_subjects = []
      course_subjects = subjects.filter {|subject| subject.course_id == course.id}
      course_subjects.each do |course_subject|
        active, count_done, count_lesson  = Learning::Batch::OpBatchService.caculate_complete_percentage(student_id, course.id, course_subject.id)
        subject = {
          :info => {
            :id => course_subject.id,
            :name => course_subject.name,
            :thumbnail => nil,
            :count_lesson => count_lesson,
            :complete_percentage => if course_subject.total_session.to_i != 0
                                      if count_done.to_f / course_subject.total_session.to_f > 1
                                        1
                                      else
                                        count_done.to_f / course_subject.total_session.to_f
                                      end
                                    else
                                      0
                                    end
          },
          :active => active
        }
        result_subjects << subject
      end
      public_course = {
        :id => course.id,
        :name => course.name,
        :subjects => result_subjects,
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
    lessons = Learning::Course::OpLession.where(subject_id: subject.id).order(:lession_number => :ASC).select(:id, :name).uniq.compact

    lesson_ids = lessons.map {|lesson| lesson.id}
    videos = Learning::Material::LearningMaterial.where(op_lession_id: lesson_ids,
                                                        material_type: Learning::Constant::Material::MATERIAL_TYPE_VIDEO,
                                                        learning_type: Learning::Constant::Material::MATERIAL_TYPE_REVIEW).to_a
    list_active_session_ids = Learning::Batch::OpBatchService.get_session_and_active_state(course_id, subject.id, student_id, lesson_ids)
    lessons.each do |lesson|
      video = videos.find{|video| video.op_lession_id == lesson.id}
      thumbnail = nil
      if !video.nil? && video.thumbnail_image.attached?
        thumbnail = video.thumbnail_image
      end
      active_session_id = list_active_session_ids.find{|item| item[:lesson_id] == lesson.id}
      if active_session_id.nil?
        active = false
        session_id = nil
      else
        active = active_session_id[:active]
        session_id = active_session_id[:session_id]
      end
      r_lesson = {
        :info => {
          :video_id => video.nil? ? '' : video.ziggeo_file_id,
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
      :short_description => course.short_description,
      :suitable_age => course.suitable_age,
      :duration => course.duration,
      :equipments => course.equipments,
      :competences => course.competences,
      :course_description => (course_description.nil? ? '' : course_description.description),
      :course_thumbnail => thumbnail,
      :active_subject => subject.id,
      :lessons => r_lessons

    } 
    course_subject_detail
  end
end

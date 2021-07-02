class Learning::Course::OpCoursesController < ApplicationController
  before_action :authenticate_admin!, except: [:public_courses, :public_course_detail, :show]
  before_action :authenticate_content_admin!, only: :show
  before_action :set_course, only: [:show]

  def index
    @courses =  Learning::Course::OpCourse.joins('INNER JOIN op_subject ON op_subject.course_id=op_course.id').group('op_course.id').order(create_date: :asc).select('op_course.id as course_id, op_course.name as course_name, count(op_subject.id) as count_subjects').to_a

    categ_ids = Learning::Course::OpCourse.pluck(:categ_id).uniq
    @categs = []
    categ_ids.each do |categ_id|
      categ = []
      if categ_id.nil?
        @categs.append [0,'Undefined']
      else
        categ = Learning::Course::CourseCateg.find(categ_id)
        @categs.append [categ.id, categ.name]
      end
    end
  end

  def index_by_category
    if params[:category_id].present?

    else

    end
  end

  def show
    @subjects = @course.op_subjects.order(level: :ASC).select(:id, :name)
    # @subjects = Learning::Course::OpSubject.where(course_id: @course.id).order(level: :asc).select(:id, :name)
    subject_ids = []
    @subjects.each do |subject|
      subject_ids.append subject.id
    end
    @lessons = Learning::Course::OpLession.where(subject_id: subject_ids).order(lession_number: :asc).select(:id, :subject_id, :name)
    @lesson_count = Hash.new(0)
    @lessons.each do |lesson|
      @lesson_count[lesson.subject_id] += 1
    end
  end

  def public_courses
    student_id = current_user.student_id
    unless student_id.nil?
      @courses = Learning::Course::OpCoursesService.get_public_courses(student_id)
    else
      @courses = []
    end
  end

  def public_course_detail
    course_id, subject_id = set_course_and_subject
    student_id = current_user.student_id

    unless course_id.nil? || student_id.nil?
      course_subject_detail = Learning::Course::OpCoursesService.get_public_course_detail(course_id, subject_id, student_id)
      course = Learning::Course::OpCourse.where(id: course_id).first
      subjects = course.op_subjects.pluck(:id, :name)
      active_subject = Learning::Course::OpSubject.where(id: course_subject_detail[:active_subject]).first
      # binding.pry
      respond_to do |format|
        format.html {
          render 'public_course_detail', :locals => {:course_subject_detail => course_subject_detail, subjects: subjects, course: course}
        }
        format.js {
          render 'learning/course/op_courses/public_course_detail', :locals => {:course_subject_detail => course_subject_detail, subjects: subjects, active_subject: active_subject}
        }
      end
    else
      redirect_to root_path
    end
  end

  private

  def set_course
    if params[:course_id].present?
      @course = Learning::Course::OpCourse.find(params[:course_id])
    end
  end

  def set_course_and_subject
    if params[:course_id].present?
      course_id = Learning::Course::OpCourse.where(id: params[:course_id]).pluck(:id).first
    else
      course_id = nil
    end
    if params[:subject_id].present?
      subject_id = Learning::Course::OpSubject.where(id: params[:subject_id]).pluck(:id).first
    else
      subject_id = nil
    end
    [course_id, subject_id]
  end
end

class Learning::Course::OpCoursesController < ApplicationController
  before_action :authenticate_admin!, except: [:public_courses]
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
    @courses = Learning::Course::OpCourse.order(:create_date)
      .limit(5)
      .to_a
  end

  private

  def set_course
    if params[:course_id].present?
      @course = Learning::Course::OpCourse.find(params[:course_id])
    end
  end
end

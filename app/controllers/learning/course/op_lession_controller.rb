class Learning::Course::OpLessionController < ApplicationController

  before_action :find_lesson, only: [:edit, :update, :preview_lesson_material, :add_vimeo, :update_vimeo]
  before_action :authenticate_admin!, only: [:index, :update, :index_by_category, :index_by_course, :index_by_subject, :update_vimeo, :add_vimeo]
  before_action :authenticate_content_admin!, only: [:preview_lesson_material, :edit]

  def index 
    @categories = Learning::Course::CourseCateg.pluck(:id,:name)
    @courses = Learning::Course::OpCourse.pluck(:id, :name)
    @subjects = Learning::Course::OpSubject.pluck(:id, :name)
    @lessons = Learning::Course::OpLession.pluck(:id, :name)
  end

  def index_by_category
    if params[:category_id].present?

      category_obj = Learning::Course::CourseCateg.find(params[:category_id])
      category = []
      category.append category_obj.id
      category.append category_obj.name
      
      categories = Learning::Course::CourseCateg.pluck(:id, :name)

      courses = Learning::Course::OpCourse.where(:categ_id => category_obj.id).pluck(:id, :name)
      course_ids = Learning::Course::OpCourse.where(:categ_id => category_obj.id).pluck(:id)

      subjects = Learning::Course::OpSubject.where(:course_id => course_ids).pluck(:id, :name)
      subject_ids = Learning::Course::OpSubject.where(:course_id => course_ids).pluck(:id)

      lessons = Learning::Course::OpLession.where(:subject_id => subject_ids).pluck(:id, :name)
      lesson_ids = Learning::Course::OpLession.where(:subject_id => subject_ids).pluck(:id)

      active_category = category
      active_course = nil
      active_subject = nil

      respond_to do |format|
        format.js {render 'learning/course/op_lession/lessons', :locals => {categories: categories,
                                                                            courses: courses,
                                                                            subjects: subjects,
                                                                            lessons: lessons,
                                                                            active_category: active_category,
                                                                            active_course: active_course,
                                                                            active_subject: active_subject}}
      end
    end
  end

  def index_by_course
    if params[:course_id].present?
      course_obj = Learning::Course::OpCourse.find(params[:course_id])
      course = []
      course.append course_obj.id
      course.append course_obj.name
      courses = Learning::Course::OpCourse.pluck(:id, :name)

      category_obj = course_obj.course_categ
      category = []
      category.append category_obj.id
      category.append category_obj.name
      categories = Learning::Course::CourseCateg.pluck(:id, :name)

      subjects = Learning::Course::OpSubject.where(:course_id => course_obj.id).pluck(:id, :name)
      subject_ids = Learning::Course::OpSubject.where(:course_id => course_obj.id).pluck(:id)
      lessons = Learning::Course::OpLession.where(:subject_id => subject_ids).pluck(:id, :name)
      lesson_ids = Learning::Course::OpLession.where(:subject_id => subject_ids).pluck(:id)

      active_category = category
      active_course = course
      active_subject = nil

      respond_to do |format|
        format.js {render 'learning/course/op_lession/lessons', :locals => {categories: categories,
                                                                            courses: courses,
                                                                            subjects: subjects,
                                                                            lessons: lessons,
                                                                            active_category: active_category,
                                                                            active_course: active_course,
                                                                            active_subject: active_subject}}
      end
    end
  end

  def index_by_subject
    if params[:subject_id].present?
      subject_obj = Learning::Course::OpSubject.find(params[:subject_id])
      subject = []
      subject.append subject_obj.id
      subject.append subject_obj.name
    
      subjects = Learning::Course::OpSubject.pluck(:id, :name)

      course_obj = subject_obj.op_course
      course = []
      course.append course_obj.id
      course.append course_obj.name
      courses = Learning::Course::OpCourse.pluck(:id, :name)

      category_obj = course_obj.course_categ
      category = []
      category.append category_obj.id
      category.append category_obj.name
      categories = Learning::Course::CourseCateg.pluck(:id, :name)

      lessons = Learning::Course::OpLession.where(:subject_id => subject_obj.id).pluck(:id, :name)
      lesson_ids = Learning::Course::OpLession.where(:subject_id => subject_obj.id).pluck(:id)

      active_category = category
      active_course = course
      active_subject = subject

      respond_to do |format|
        format.js {render 'learning/course/op_lession/lessons', :locals => {categories: categories,
                                                                            courses: courses,
                                                                            subjects: subjects,
                                                                            lessons: lessons,
                                                                            active_category: active_category,
                                                                            active_course: active_course,
                                                                            active_subject: active_subject}}
      end
    end
  end

  def edit
    @questions = @lesson.questions
    @subject = @lesson.op_subject
    @course = @subject.op_course
  end

  def update
    
  end

  def preview_lesson_material
    @questions = @lesson.questions
    @subject = @lesson.op_subject
    @course = @subject.op_course
  end

  private

  def find_lesson
    @lesson = Learning::Course::OpLession.find(params[:lession_id])
  end

  def authenticate_admin!
    unless current_user.is_admin?
      flash[:danger] = 'Bạn không có quyền truy cập đến tài nguyên này'
      redirect_to root_path
    end
  end
end

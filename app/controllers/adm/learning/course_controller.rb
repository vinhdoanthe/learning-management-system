class Adm::Learning::CourseController < ApplicationController

  include ApplicationHelper

  #verify token authenticity
  skip_before_action :verify_authenticity_token

  # filters
  def filters

    # Danh sach
    @list_course = Learning::Course::OpCoursesService.get_courses(params[:keywords].to_s.strip)

    render partial: 'adm/learning/course/list_course'    
  end

  # Danh sach khoa hoc
  def index

    @report_title_page = t('adm.course.management_course')

    @param_form = Learning::Course::OpCoursesService.form_paramater(params, request)

    keywords = @param_form[:keywords]

    # Danh sach khoa hoc
    @list_course = Learning::Course::OpCoursesService.get_courses(keywords)		
  end

  # Chi tiet khoa hoc
  def show
    @report_title_page = t('adm.course.management_course')

    @course = []

    if params[:course_id].present?
      @course   = Learning::Course::OpCourse.find(params[:course_id])
      # Chuong trinh hoc
      @subjects = @course.op_subjects.order(level: :ASC).select(:id, :name)

      @lessions = Learning::Course::OpCoursesService.get_all_lession_of_course(params[:course_id])
    else
      flash[:warning] = t("adm.Object does not exist")
    end	    
  end

  # Edit khoa hoc
  def edit
    @report_title_page = t('adm.course.management_course')

    @course = []

    if params[:course_id].present?
      @course   = Learning::Course::OpCourse.find(params[:course_id])
      # Chuong trinh hoc
      @subjects = @course.op_subjects.order(level: :ASC).select(:id, :name)

      @lessions = Learning::Course::OpCoursesService.get_all_lession_of_course(params[:course_id])
    end

  end

  # update khoa hoc
  def update

    course = []

    if params[:frm_course][:course_id].present?

      course_description   = Learning::Course::CourseDescription.find_by(op_course_id: params[:frm_course][:course_id])

      if course_description.nil?
        flash[:danger] = t("adm.Object does not exist")
        redirect_to adm_learning_course_path
      else

        if course_description.update(description: params[:frm_course][:description])
          flash[:success] = t("adm.The item was updated successfully")		  		
        else
          flash[:danger] = t("adm.The item was updated fail")
        end

        redirect_to adm_learning_course_edit_path(params[:frm_course][:course_id])

      end
    end
  end
end

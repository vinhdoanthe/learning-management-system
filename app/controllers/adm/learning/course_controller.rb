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
end
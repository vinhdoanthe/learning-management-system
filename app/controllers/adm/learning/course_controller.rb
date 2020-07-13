class Adm::Learning::CourseController < ApplicationController

	include ApplicationHelper

	#verify token authenticity
	skip_before_action :verify_authenticity_token

	# Danh sach khoa hoc
	def index
		
		@report_title_page = t('adm.course.management_course')

		@param_form = Learning::Course::OpCoursesService.form_paramater(params, request)

		course_name = @param_form[:course_name]
		course_code = @param_form[:course_code]

		# Danh sach
		@list_course = Learning::Course::OpCoursesService.get_courses(course_name, course_code)


		#@list_batch = Learning::Course::OpCoursesService(batch_params)

		#puts @list_batch
		
		return
	end
end
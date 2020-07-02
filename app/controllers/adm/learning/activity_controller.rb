class Adm::Learning::ActivityController < ApplicationController

	include ApplicationHelper

	#verify token authenticity
	skip_before_action :verify_authenticity_token

	# Quan ly Bai tap ve nha
	def homework
		@report_title_page = t('adm.learning_activity_management_homework')

		@param_form = Learning::Homework::UserAnswerService.form_paramater(params, request)

		# Danh sach
		@list_user_answers = Learning::Homework::UserAnswerService.get_user_answers_type_question_text(@param_form)

		puts @list_user_answers

		return
	end
end
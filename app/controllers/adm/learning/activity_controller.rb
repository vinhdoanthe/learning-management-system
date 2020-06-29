module Adm
	module Learning
		class ActivityController < ApplicationController

			include ApplicationHelper

			#verify token authenticity
			skip_before_action :verify_authenticity_token

	  		# Quan ly Bai tap ve nha
	  		def homework
	  			@report_title_page = t('adm.learning_activity_management_homework')

	  			return SocialCommunity::QuestionAnswer::UserAnswerService::get_user_answers_type_question_text params

	  		end
	  	end
  	end
end
class Learning::Course::OpLessionController < ApplicationController
	before_action :find_lesson
	before_action :authenticate_admin!, only: :preview_lesson_material

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

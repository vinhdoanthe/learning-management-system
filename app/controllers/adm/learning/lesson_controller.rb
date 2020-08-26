class Adm::Learning::LessonController < ApplicationController

  include ApplicationHelper

  #verify token authenticity
  skip_before_action :verify_authenticity_token

  # Chi tiet Lesson
  def show
    @report_title_page = t('adm.course.management_course')

    @obj_lesson = []

    @learning_material_type = [
      {'title' => "Giáo án"},
      {'title' => "Videos"},
      {'title' => "Slider"}
    ]

    if params[:lesson_id].present?

      @obj_lesson     = Learning::Course::OpLession.find(params[:lesson_id])

      @op_subject     = @obj_lesson.op_subject
      @op_course_name = @obj_lesson.op_course_name

      @obj_lesson_learning_materials = @obj_lesson.learning_materials.select(:id,:title, :material_type, :learning_type, :google_drive_link, :ziggeo_file_id, :content_type)


      

    else
      flash[:danger] = t("adm.course.lesson.Lesson does not exist")
    end

  end # END: show

end

class Adm::Learning::LessonController < ApplicationController

  include ApplicationHelper

  #verify token authenticity
  skip_before_action :verify_authenticity_token

  # Chi tiet Lesson
  def show
    @report_title_page = t('adm.course.management_course')

    @obj_lesson_learning_materials = @obj_lesson = []

    if params[:lesson_id].present?

      @obj_lesson     = Learning::Course::OpLession.find(params[:lesson_id])
      @op_subject     = @obj_lesson.op_subject
      @op_course_name = @obj_lesson.op_course_name
      @obj_lesson_learning_materials = @obj_lesson.learning_materials.select(:id,:title,:description, :material_type, :learning_type, :google_drive_link, :ziggeo_file_id, :content_type)
    else
      
      flash[:danger] = t("adm.course.lesson.Lesson does not exist")
    
    end

  end # END: show

  def learning_material_edit

    if params[:learning_material_id].present?
      
      @obj_learning_material     = Learning::Material::LearningMaterial.find(params[:learning_material_id])

      if @obj_learning_material.material_type.to_s == 'file' && @obj_learning_material.learning_type.to_s == 'teach' && @obj_learning_material.content_type.to_s == 'lesson_plan'

       form_lesson_learning_material = 'form_lesson_learning_materials_lessonplan'

      elsif @obj_learning_material.material_type.to_s == 'file' && @obj_learning_material.learning_type.to_s == 'teach' && @obj_learning_material.content_type.to_s == 'presentation'
      
        form_lesson_learning_material = 'form_lesson_learning_materials_slide'
      elsif @obj_learning_material.material_type.to_s == 'video' && @obj_learning_material.learning_type.to_s == 'review'
        form_lesson_learning_material = 'form_lesson_learning_materials_vimeo'
      else

      end
    
    else
      
      flash[:danger] = t("adm.course.lesson.Lesson does not exist")
    
    end

    render partial: "adm/learning/lesson/#{form_lesson_learning_material}"

  end # END learning_material_edit

  def learning_material_update

      if params[:learning_material_id].present?
        
        @obj_learning_material     = Learning::Material::LearningMaterial.find(params[:learning_material_id])

        if @obj_learning_material.material_type.to_s == 'file' && @obj_learning_material.learning_type.to_s == 'teach' && @obj_learning_material.content_type.to_s == 'lesson_plan'

         form_lesson_learning_material = 'form_lesson_learning_materials_lessonplan'

        elsif @obj_learning_material.material_type.to_s == 'file' && @obj_learning_material.learning_type.to_s == 'teach' && @obj_learning_material.content_type.to_s == 'presentation'
        
          form_lesson_learning_material = 'form_lesson_learning_materials_slide'
        elsif @obj_learning_material.material_type.to_s == 'video' && @obj_learning_material.learning_type.to_s == 'review'
          form_lesson_learning_material = 'form_lesson_learning_materials_vimeo'
        else

        end
      
      else
        
        flash[:danger] = t("adm.course.lesson.Lesson does not exist")
      
      end

      render partial: "adm/learning/lesson/#{form_lesson_learning_material}"

    end # END learning_material_edit


end

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

  end # END learning_material_update

  # Update lesson info: Slide; Video; Bai giang
  def lesson_learning_materials_update

    if params[:subject_id].present?

      @op_subject = Learning::Course::OpSubject.find(params[:subject_id])

      if @op_subject.blank?
        flash[:danger] = t("adm.course.lesson.Subject does not exist")
      else

        # get list lesson of subject_id
        @lessons = @op_subject.op_lessions.order(lession_number: :ASC).select(:id, :name, :lession_number)

        #@learning_materials = @lessons.learning_materials.select(:id,:title,:description, :material_type, :learning_type, :content_type, :google_drive_link, :ziggeo_file_id)

        render partial: "adm/learning/lesson/list_lesson_form"

      end

    else

      flash[:danger] = t("adm.course.lesson.Subject does not exist")

    end

  end # END: lesson_learning_materials_update

  # lesson_learning_materials_update_process
  def lesson_learning_materials_update_process

    if params[:frm_learning_material][:subject_id].present?

      frm_lesson_learning_material = params[:frm_learning_material][:learning_material]

      frm_lesson_learning_material.each  do |key, learning_material|

        lesson_id = key

        #puts learning_material
        learning_material.each  do |key , obj_material|

          document_type      = key

          puts "document_type: #{key}"

          obj_material_id    = 0
          obj_material_value = ''

          obj_material.each  do |key , material|

            #key_temp = key.to_s
            obj_material_id    = key.to_i
            obj_material_value = material

          end              

          if document_type == 'document'
            material_type = 'file'
            learning_type = 'teach'
            content_type  = 'lesson_plan'
          elsif document_type == 'slide'
            material_type = 'file'
            learning_type = 'teach'
            content_type  = 'presentation'
          elsif document_type == 'video'
            material_type = 'video'
            learning_type = 'review'
            content_type  = ''                
          end

          if (obj_material_id.to_i > 0) # Update

            obj_learning_material = Learning::Material::LearningMaterial.find(obj_material_id.to_i)

            if obj_learning_material.present?
              if (obj_learning_material[:material_type] == 'video' &&  obj_learning_material[:learning_type] == 'review')
                obj_learning_material.update(ziggeo_file_id: obj_material_value)
              else
                obj_learning_material.update(google_drive_link: obj_material_value)
              end
            end
          elsif (obj_material_id.to_i <= 0 && obj_material_value != '')

            if document_type == 'video'
              obj_learning_material = Learning::Material::LearningMaterial.new(material_type: material_type, learning_type: learning_type, content_type: content_type, ziggeo_file_id: obj_material_value,op_lession_id: lesson_id)
            else
              obj_learning_material = Learning::Material::LearningMaterial.new(material_type: material_type, learning_type: learning_type, content_type: content_type, google_drive_link: obj_material_value,op_lession_id: lesson_id)
            end
            obj_learning_material.save

          end

          if ()

          end

        end

      end

    end

  end
end

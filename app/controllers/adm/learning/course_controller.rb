 Adm::Learning::CourseController < ApplicationController

  include ApplicationHelper

  #verify token authenticity
  skip_before_action :verify_authenticity_token

  # filters
  def filters

    # Danh sach
    puts "FORM: "
    puts params[:active]
    
    #binding.pry

    @list_course = Learning::Course::OpCoursesService.get_courses(params[:keywords].to_s.strip, params[:active])

    render partial: 'adm/learning/course/list_course'    
  end

  # Danh sach khoa hoc
  def index

    @report_title_page = t('adm.course.management_course')

    @param_form = Learning::Course::OpCoursesService.form_parameter(params, request)

    keywords = @param_form[:keywords]
    status   = @param_form[:active]

    # Danh sach khoa hoc
    #@list_course = Learning::Course::OpCoursesService.get_courses(keywords, status)

    @list_course = []
  end

  # Chi tiet khoa hoc
  def show
    @report_title_page = t('adm.course.management_course')

    @course = @subjects = []

    if params[:course_id].present?

      @course   = Learning::Course::OpCourse.find(params[:course_id])
      
      # Chuong trinh hoc
      @subjects = @course.op_subjects.order(level: :ASC).select(:id, :name)

      #@subjects = Learning::Course::OpSubject.where(course_id: params[:course_id]).order(level: :ASC).select(:id, :name)

      #@lessions = Learning::Course::OpCoursesService.get_all_lession_of_course(params[:course_id])

    else
      flash[:warning] = t("adm.Object does not exist")
    end	    
  end

  # get lesson by session_id
  def get_lesson_by_session
    
    subject_id = params[:subject_id].to_i
    @lessions  = []

    if subject_id > 0
      #@course   = Learning::Course::OpCourse.find(params[:course_id])
      # Chuong trinh hoc
      #@lessions = Learning::Course::OpCoursesService.get_all_lession_of_course(params[:subject_id].to_i)

      @lessions = Learning::Course::OpLession.where(subject_id: subject_id).order(lession_number: :ASC).select(:id, :name, :code, :note, :write_date)
      #.select(:id, :name, :code, :note, :write_date)
    else
      flash[:warning] = t("adm.Object does not exist")
    end

    render partial: 'adm/learning/course/list_lesson'

  end

  # Edit khoa hoc
  def edit
    
    @report_title_page = t('adm.course.management_course')

    @course = nil

    if params[:course_id].present?
      @course   = Learning::Course::OpCourse.find(params[:course_id])

      # Chuong trinh hoc
      @subjects = @course.op_subjects.order(level: :ASC).select(:id, :name)

      #@lessions = Learning::Course::OpCoursesService.get_all_lession_of_course(params[:course_id])

      course_descriptions = @course.course_description        
      course_description  = course_descriptions.blank? ? '' : course_descriptions[0].description

      @frm_course = {
        'suitable_age': @course.suitable_age,
        'duration': @course.duration,
        'equipments': @course.equipments,
        'prerequisites': @course.prerequisites,          
        'short_description': @course.short_description,
        'description': course_description,
        'competences': @course.competences,
      }

      @valid_messages = nil

    end

    if @course.nil?
      flash[:danger] = t("adm.Object does not exist")
      redirect_to adm_learning_course_path
    end
  end

  # update khoa hoc
  def update

    @frm_course = course = []

    if params[:frm_course][:course_id].present?

      course   = Learning::Course::OpCourse.find(params[:frm_course][:course_id])
      course_description   = Learning::Course::CourseDescription.find_by(op_course_id: params[:frm_course][:course_id])

      if course_description.nil?
        flash[:danger] = t("adm.Object does not exist")
        redirect_to adm_learning_course_path
      else

        course_update = course.update(
          suitable_age: params[:frm_course][:suitable_age],
          duration: params[:frm_course][:duration],
          equipments: params[:frm_course][:equipments],
          prerequisites: params[:frm_course][:prerequisites],
          short_description: params[:frm_course][:short_description],
          competences: params[:frm_course][:competences],
          write_date: Time.now
        )

        if course_description.update(description: params[:frm_course][:description]) && course_update
          
          if params[:frm_course][:thumbnail].present?
            course.thumbnail.attach(params[:frm_course][:thumbnail])
          end

          flash[:success] = t("adm.The item was updated successfully")
          redirect_to adm_learning_course_edit_path(params[:frm_course][:course_id])
        else
          
          @valid_messages = course.errors.messages

          flash[:danger] = t("adm.The item was updated fail")
          #@frm_course = params[:frm_course]

          @frm_course = {
            'suitable_age': params[:frm_course][:suitable_age].to_s,
            'duration': params[:frm_course][:duration],
            'equipments': params[:frm_course][:equipments],
            'prerequisites': params[:frm_course][:prerequisites],            
            'short_description': params[:frm_course][:short_description],
            'description': params[:frm_course][:description],
            'competences': params[:frm_course][:competences]
          }

          @subjects   = course.op_subjects.order(level: :ASC).select(:id, :name)
          @course     = course

          @course_update = course_update

          render 'adm/learning/course/edit'
        end
      end
    end
  end # End function update


  # Function uplaod photo for subject and lesson
  def subject_upload
    
    if params[:frm_subject][:subject_id].present? && params[:frm_subject][:course_id].present?

      number_upload_photo_lesson = 0

      op_subject   = Learning::Course::OpSubject.find(params[:frm_subject][:subject_id])

      if params[:frm_subject][:thumbnail].present?

        if params[:frm_subject][:thumbnail].content_type == 'image/jpeg' or params[:frm_subject][:thumbnail].content_type == 'image/png'
        
          op_subject.thumbnail.attach(params[:frm_subject][:thumbnail])
          flash[:success] = t('adm.course.Update photo Subject successful.')
        else
          flash[:danger] = t('adm.course.Upload photo Subject fail.')
        end
      end

      if params[:frm_subject][:lesson_thumbnail].present?
        
        # get lesson of subject
        lessions = Learning::Course::OpLession.where(subject_id: params[:frm_subject][:subject_id]).order(lession_number: :ASC)

        if lessions.length <= 0
          flash[:warning] = t('adm.course.This Subject has no lesson.')        
        else
          
          params[:frm_subject][:lesson_thumbnail].each  do |lesson_thumbnail|
          
            original_filename = lesson_thumbnail.original_filename
            file_content_type = lesson_thumbnail.content_type

            if file_content_type == 'image/jpeg' or file_content_type == 'image/png'

              # Lay ten file khong chua phan mo rong
              first_filename = File.basename(original_filename, File.extname(original_filename))

              lessions.each  do |lesson|
                
                if lesson.lession_number.to_i == first_filename.to_i
                  lesson.thumbnail.attach(lesson_thumbnail)
                  number_upload_photo_lesson = number_upload_photo_lesson + 1
                  break
                end
              end
            end
          
            #binding.pry
          end #end for each
          
          if number_upload_photo_lesson > 0
            flash[:success] = t('adm.course.Upload photo Lessons successful', total_photo_lesson: number_upload_photo_lesson)
          else
            flash[:warning] = t('adm.course.Upload photo Lessons fail').html_safe
          end

        end
      else
        flash[:warning] = t('adm.course.You do not choose to upload pictures for the lesson.')
      end

      redirect_to adm_learning_course_edit_path(params[:frm_subject][:course_id])
    
    else
      # If error param then goto course index
      
      flash[:danger] = t("adm.Object does not exist")
      redirect_to adm_learning_course_path      
    end

    #binding.pry

    #render partial: 'adm/learning/course/subject_upload'    

  end# END: subject_upload

end

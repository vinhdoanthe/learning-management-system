module Learning
  class LearningMaterialsController < ApplicationController
    before_action :authenticate_faculty!, only: [:show_google_doc_materials]

    def show_google_doc_materials
      file = Learning::Material::LearningMaterial.where(material_type: Learning::Constant::Material::MATERIAL_TYPE_FILE).last
      @files = Array.new
      if params[:session_id].present?
        session = Learning::Batch::OpSession.find(params[:session_id])
        if session.nil?
          @files = file
        else
          @files = Learning::Material::LearningMaterial::get_drive_files(session.lession_id)
        end
      else
        @files = file
      end
      respond_to do |format|
        format.js {render 'learning/show_google_doc_files'}
      end
    end


    def list_slides_of_subject
      lessons = Learning::Course::OpLession.where(subject_id: params[:subject_id].to_i).pluck(:id,:name).uniq.compact
      lessons.sort_by! { |lesson| lesson[0] }

      respond_to do |format|
        format.js {render 'learning/list_slides', locals: {lessons: lessons}}
      end
    end

    def show_google_slide
      lesson = Learning::Course::OpLession.where(id: params[:lesson_id]).first
      video = lesson.learning_materials.where(material_type: 'video').first
      video_id = video&.ziggeo_file_id
      link, plan_link = '',''

      if lesson.present?
        slide = Learning::Material::LearningMaterial.where(material_type: Learning::Constant::Material::MATERIAL_TYPE_FILE, 
                                                           learning_type: Learning::Constant::Material::MATERIAL_TYPE_TEACH, 
                                                           content_type: Learning::Constant::Material::MATERIAL_CONTENT_PRESENTATION, 
                                                           op_lession_id: lesson.id).first
        plan = Learning::Material::LearningMaterial.where(material_type: Learning::Constant::Material::MATERIAL_TYPE_FILE, 
                                                          learning_type: Learning::Constant::Material::MATERIAL_TYPE_TEACH,
                                                          content_type: Learning::Constant::Material::MATERIAL_CONTENT_LESSON_PLAN, 
                                                          op_lession_id: lesson.id).first

        link = if slide.present?
                 slide.google_drive_link
               else
                 ''
               end

        plan_link = if plan.present?
                      plan.google_drive_link
                    else
                      ''
                    end
      end

      respond_to do |format|
        format.js {render 'learning/show_google_slide', locals: { link: link, plan_link: plan_link, video_id: video_id, video: video }}
      end
    end

    def show_video
      lesson = ''
      session = ''
      name = ''
      errors = ''
      video = ''
      @video_id = ''

      if params[:session_id].present?
        session = Learning::Batch::OpSession.where(id: params[:session_id]).first
        if session.blank?
          errors = 'Không có video!'
        else
          if session.lession_id.blank?
            session = current_user.op_student.op_sessions.where('start_datetime <= ?', Time.now).where(state: Learning::Constant::Batch::Session::STATE_DONE, subject_id: params[:subject_id], batch_id: params[:batch_id]).where.not(lession_id: nil).order(start_datetime: :DESC).first
            lesson = session.op_lession if session.present?
          else
            lesson = session.op_lession
          end
          session_video = Learning::Material::LearningMaterial.where(material_type: Learning::Constant::Material::MATERIAL_TYPE_VIDEO, :op_lession_id => session.lession_id).order(created_at: :DESC).first if session.present?
          if session_video.present?
            video = session_video
            @video_id = video.ziggeo_file_id
            name = session_video.title
          else
            name = ''
            errors = 'Không có video!'
          end
        end
      else
        errors = 'Không có video!'
      end

      respond_to do |format|
        format.js {render 'learning/show_homework_video', :locals => { session: session, video_id: @video_id, lesson: lesson, name: name, errors: errors, video: video }}
      end
    end

    def next_video
      session = Learning::Batch::OpSession.where(id: params[:session_id]).first
      if session.blank?
        render json: { status: 500, type: 'danger', message: 'Đã có lỗi xảy ra! Thử lại sau'}
      else
        videos = Learning::Material::LearningMaterial.where(material_type: Learning::Constant::Material::MATERIAL_TYPE_VIDEO, :op_lession_id => session.lession_id).order(created_at: :DESC)
        #index_value = params[:videos_index].key[0] + params[:video_index].values[0]
        current_video = Learning::Material::LearningMaterial.find(params[:video_index].to_i)
        current_video_index = videos.find_index(current_video)
        index_value = current_video_index + params[:index].to_i

        if index_value < 0 || index_value >= videos.length
          data = find_next_video current_user.op_student, session, params[:index]
          video = data[:video]
          next_session = data[:session] 
          if video.present?
            @video_id = video.ziggeo_file_id
          else
            @video_id = nil

            name = (session && session.op_lession) ? session.op_lession.name : (session.name || 'Đang cập nhật')
            respond_to do |format|
              format.js {render 'learning/show_video', :locals => {:target => 'watch_video_box', name: name, session_id: next_session.id, session: next_session, video_id: nil}}
            end
            return
          end

        else
          video = videos[index_value]
          @video_id = video.ziggeo_file_id
        end

        name = (session && session.op_lession) ? session.op_lession.name : (session.name || 'Đang cập nhật')
        respond_to do |format|
          format.js {render 'learning/show_video', :locals => {:target => 'watch_video_box', name: name, session_id: next_session.id, session: next_session, video_id: video.id}}
        end
      end
    end

    def add_vimeo
      if params[:lesson_id].present? and params[:file_id].present?
        lesson = Learning::Course::OpLession.where(id: params[:lesson_id]).first
        return if lesson.nil?

        video = Learning::Material::LearningMaterial.new
        video.op_lession_id = lesson.id
        video.title = lesson.name
        video.material_type = Learning::Constant::Material::MATERIAL_TYPE_VIDEO
        video.learning_type = Learning::Constant::Material::MATERIAL_TYPE_REVIEW
        video.ziggeo_file_id = params[:file_id]
        video.save
        if params[:thumbnail].present?
          video.thumbnail_image.attach(params[:thumbnail])
        end
        respond_to do |format|
          format.html {redirect_to learning_preview_lesson_path(lesson.id)}
          format.js {}
        end
      end
    end

    def update_vimeo
      if params[:lesson_id].present? and params[:video_id].present? and params[:file_id].present?
        lesson = Learning::Course::OpLession.where(id: params[:lesson_id]).first
        return if lesson.nil?
        video = Learning::Material::LearningMaterial.where(id: params[:video_id]).first
        return if video.nil?
        video.title = lesson.name
        video.ziggeo_file_id = params[:file_id]
        video.save
        if params[:thumbnail].present?
          if video.thumbnail_image.attached?
            video.thumbnail_image.purge
          end
          video.thumbnail_image.attach(params[:thumbnail])
        end
        respond_to do |format|
          format.html {redirect_to learning_preview_lesson_path(lesson.id)}
          format.js {}
        end
      end 
    end

    def ziggeo
      @videos = Learning::Material::LearningMaterial.ziggeo_list_video
      respond_to do |format|
        format.html { render :template => "learning/material/ziggeo" }
      end
    end

    def view_learning_material
      redirect_to root_path
    end

    def get_video_list
      session = Learning::Batch::OpSession.find(params[:session])
      course = Learning::Course::OpCourse.find(session.course_id)
      batch = session.op_batch
      subject = session.op_subject
      sessions = batch.op_sessions.where(subject_id: subject.id)
      @session = session

      respond_to do |format|
        format.js { render 'learning/get_list_videos', locals: { sessions: sessions, session: session, course: course, batch: batch, subject: subject }}
      end
    end

    private

    def find_next_video student, session, index
      batch = session.op_batch
      subject_ids = []

      student.op_student_courses.each do |sc|
        subject_ids << sc.op_subjects.pluck(:id)
      end

      subject_ids.flatten!
      sessions = batch.op_sessions.joins(:op_lession).where(op_lession: {subject_id: subject_ids}).order(start_datetime: :DESC)
      video = ''
      while video.blank? || session == sessions[0] || session == sessions[-1]
        session_index = sessions.find_index(session)
        if (session_index + index.to_i) == sessions.length || (session_index + index.to_i) < 0
          break				
        end
        session = sessions[sessions.find_index(session) + index.to_i]
        video = Learning::Material::LearningMaterial.where(material_type: Learning::Constant::Material::MATERIAL_TYPE_VIDEO, :op_lession_id => session.lession_id).order(created_at: :DESC).first
      end
      { video: video, session: session }
    end
  end
end

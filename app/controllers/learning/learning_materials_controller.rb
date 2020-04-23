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


    def show_video
      video = Learning::Material::LearningMaterial.where(material_type: Learning::Constant::Material::MATERIAL_TYPE_VIDEO).last
      fallback_video_id = Learning::Constant::Material::DEFAULT_VIDEO_ID
      lesson = ''
      session = ''
      name = ''

      if params[:session_id].present?
        session = Learning::Batch::OpSession.where(id: params[:session_id]).first
        if session.nil?
          @video_id = fallback_video_id
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
            @video_id = fallback_video_id
          end
        end
      else
        @video_id = fallback_video_id
      end
      
      respond_to do |format|
        format.js {render 'learning/show_homework_video', :locals => { session: session, video_id: @video_id, lesson: lesson, name: name }}
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

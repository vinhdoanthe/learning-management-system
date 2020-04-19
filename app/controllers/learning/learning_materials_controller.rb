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
      if params[:subject_id].present?
        lesson_ids = Learning::Course::OpLession.where(subject_id: params[:subject_id].to_i).pluck(:id).uniq.compact
        slides = []
        unless lesson_ids.blank?
          slides = Learning::Material::LearningMaterial.where(material_type: Learning::Constant::Material::MATERIAL_TYPE_FILE, op_lession_id: lesson_ids).pluck(:id,:title).uniq.compact 
        end
        respond_to do |format|
          format.js {render 'learning/list_slides', locals: {slides: slides}}
        end
      end
    end

    def show_google_slide
      if params[:slide_id].present?
        slide = Learning::Material::LearningMaterial.where(id: params[:slide_id].to_i).first
        if slide.nil?
          link = ''
        else
          link = slide.google_drive_link
        end
        respond_to do |format|
          format.js {render 'learning/show_google_slide', locals: {link: link}}
        end
      end
    end

    def show_video
      video = Learning::Material::LearningMaterial.where(material_type: Learning::Constant::Material::MATERIAL_TYPE_VIDEO).last
      fallback_video_id = video.nil? ? 'Không có video nào' : video.ziggeo_file_id

      if params[:session_id].present?
        session = Learning::Batch::OpSession.where(id: params[:session_id]).first
        if session.nil?
          @video_id = fallback_video_id
        else
          session_video = Learning::Material::LearningMaterial.where(material_type: Learning::Constant::Material::MATERIAL_TYPE_VIDEO, :op_lession_id => session.lession_id).order(created_at: :DESC).first
          if session_video.present?
            video = session_video
            @video_id = video.ziggeo_file_id
          else
            @video_id = fallback_video_id
          end
        end
      else
        @video_id = fallback_video_id
      end
      name = ''

      if session.present?
        name = session.op_subject.name
        name = session.op_lession.name if session.op_lession.present?
      end

      respond_to do |format|
        format.js {render 'learning/show_video', :locals => {:target => params[:target], name: name, session_id: session.id, session: session, video_id: video.id}}
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

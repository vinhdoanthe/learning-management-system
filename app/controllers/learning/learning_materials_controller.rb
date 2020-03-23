module Learning
  class LearningMaterialsController < ApplicationController
    before_action :authenticate_faculty!, only: [:show_google_doc_materials]
    # skip_before_action :authenticate_user!, only: [:view_learning_material]

    def show_pdf
      file = Learning::Material::LearningMaterial.where(material_type: Learning::Constant::Material::MATERIAL_TYPE_FILE).last
      if params[:session_id].present?
        session = Learning::Batch::OpSession.find(params[:session_id])
        if session.nil?
          @files = file
        else
          @files = Learning::Material::LearningMaterial.where(material_type: Learning::Constant::Material::MATERIAL_TYPE_FILE,
                                                              :op_lession_id => session.lession_id).first
          if @files.blank?
            @files = file
          end
        end
      else
        @files = file
      end

      respond_to do |format|
        format.js {render 'learning/show_pdf'}
      end
    end

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
      @pretty_files = Array.new
      @file_publish_links = []
      @files.each do |tmp_file|
        drive_object = tmp_file.get_drive_object
        unless drive_object.nil?
          pretty_file = {}
          pretty_file['id'] = drive_object.id
          pretty_file['has_thumbnail'] = drive_object.has_thumbnail
          pretty_file['icon_link'] = drive_object.icon_link

          pretty_file['thumbnail_link'] = drive_object.thumbnail_link
          pretty_file['web_view_link'] = drive_object.web_view_link
          # pretty_file = tmp_file.get_drive_object
          pretty_file['google_drive_link'] = tmp_file.google_drive_link
          @pretty_files.append pretty_file
          # @file_publish_link.append tmp_file.google_drive_link
        end
      end
      # binding.pry
      respond_to do |format|
        format.js {render 'learning/show_google_doc_files'}
      end
    end

    # def show_google_doc_materials
    #   file = Learning::Material::LearningMaterial.where(material_type: Learning::Constant::Material::MATERIAL_TYPE_FILE).last
    #   @files = Array.new
    #   if params[:session_id].present?
    #     session = Learning::Batch::OpSession.find(params[:session_id])
    #     if session.nil?
    #       @files = file
    #     else
    #       @files = Learning::Material::LearningMaterial::get_drive_files(session.lession_id)
    #     end
    #   else
    #     @files = file
    #   end
    #   @pretty_files = Array.new
    #   @files.each do |tmp_file|
    #     pretty_file = tmp_file.get_drive_object
    #     @pretty_files.append pretty_file unless pretty_file.nil?
    #   end
    #   # binding.pry
    #   respond_to do |format|
    #     format.js {render 'learning/show_google_doc_files'}
    #   end
    # end

    def show_video
      video = Learning::Material::LearningMaterial.where(material_type: Learning::Constant::Material::MATERIAL_TYPE_VIDEO).last
			fallback_video_id = video.ziggeo_file_id
      
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
			#binding.pry
     ##  name = (session && session.op_lession) ? session.op_lession.name : (session.name || 'Đang cập nhật')
      # if session.present?
      #   name = session.name
      #   name = session.op_lession.name if session.op_lession.present?
      # else
      #   name = session.op_subject.name
      # end
      name = ''
      name = session.op_subject.name
      name = session.op_lession.name if session.op_lession.present?

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
					#	next_session = find_next_session current_user.op_student, session, params[:index]
					#	video = Learning::Material::LearningMaterial.where(material_type: Learning::Constant::Material::MATERIAL_TYPE_VIDEO, :op_lession_id => next_session.lession_id).order(created_at: :DESC).first
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

    def pdf_materials
      if params[:session_id].present?
        session = Learning::Batch::OpSession.find(params[:session_id])
        if session.nil?
          render :json => {'success': false,
                           'code': '',
                           'message': 'Không tìm được session'}
        else
          @pdf_materials = Learning::Material::LearningMaterial.where(:op_lession_id => session.lession_id).to_a
          if !@pdf_materials.blank?
            render :json => {
              'success': true,
              'code': '',
              'message': 'Lấy dữ liệu thành công',
              'data': @pdf_materials
            }
          else
            render :json => {'success': true,
                             'code': '',
                             'message': 'Lesson này chưa có học liệu',
                             'data': []}
          end
        end
      else
        render :json => {'success': false,
                         'code': '',
                         'message': 'Không có session ID'}
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

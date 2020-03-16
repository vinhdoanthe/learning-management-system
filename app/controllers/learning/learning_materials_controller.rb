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
          pretty_file['has_thumbnail'] = drive_object.has_thumbnail
          pretty_file['icon_link'] = drive_object.icon_link

          pretty_file['thumbnail_link'] = drive_object.thumbnail_link
          pretty_file = tmp_file.get_drive_object
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
      fallback_video = Learning::Material::LearningMaterial.where(material_type: Learning::Constant::Material::MATERIAL_TYPE_VIDEO).last
      if params[:session_id].present?
        session = Learning::Batch::OpSession.find(params[:session_id])
        if session.nil?
          @video_file = fallback_video
        else
          @video_file = Learning::Material::LearningMaterial.where(material_type: Learning::Constant::Material::MATERIAL_TYPE_VIDEO,
                                                                   :op_lession_id => session.lession_id).first
          if @pdf_file.blank?
            @video_file = fallback_video
          end
        end
      else
        @video_file = fallback_video
      end

      name = (session && session.op_lession) ? session.op_lession.name : (session.name || 'Đang cập nhật')
      respond_to do |format|
        format.js {render 'learning/show_video', :locals => {:target => params[:target], name: name, session_id: session.id}}
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
  end
end

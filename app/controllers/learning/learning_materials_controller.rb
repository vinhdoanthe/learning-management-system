module Learning
  class LearningMaterialsController < ApplicationController
    # before_action :authenticate_faculty!, only: [:pdf_materials]
    # skip_before_action :authenticate_user!, only: [:view_learning_material]

    def show_pdf
      fallback_pdf_file = Learning::Material::LearningMaterial.where(material_type: Learning::Constant::Material::MATERIAL_TYPE_FILE).last
      if params[:session_id].present?
        session = Learning::Batch::OpSession.find(params[:session_id])
        if session.nil?
          @pdf_file = fallback_pdf_file
        else
          @pdf_file = Learning::Material::LearningMaterial.where(material_type: Learning::Constant::Material::MATERIAL_TYPE_FILE,
                                                                 :op_lession_id => session.lession_id).first
          if @pdf_file.blank?
            @pdf_file = fallback_pdf_file
          end
        end
      else
        @pdf_file = fallback_pdf_file
      end

      respond_to do |format|
        format.js {render 'learning/show_pdf'}
      end
    end

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

      name = session.op_lession ? session.op_lession.name : session.name
      respond_to do |format|
        format.js {render 'learning/show_video', :locals => {:target => params[:target], name: name}}
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
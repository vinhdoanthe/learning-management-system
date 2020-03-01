module Learning
  class LearningMaterialsController < ApplicationController
    before_action :authenticate_faculty!, only: [:pdf_materials]
    skip_before_action :authenticate_user!, only: [:view_learning_material]

    def view_learning_material
      if params[:material_id].present?
        @learning_material = Learning::Course::LearningMaterial.find(params[:material_id].to_i)
        if @learning_material.material_type == Learning::Constant::Course::MATERIAL_TYPE_FILE
          respond_to do |format|
            format.html {render :template => 'learning/show_pdf'}
          end
        else
        end
      else
        flash[:danger] = "Bạn không có quyền truy cập đến tài nguyên này"
        redirect_to root_path
      end
    end

    def pdf_materials
      if params[:session_id].present?
        session = Learning::Batch::OpSession.find(params[:session_id])
        if session.nil?
          render :json => {'success': false,
                           'code': '',
                           'message': 'Không tìm được session'}
        else
          @pdf_materials = Learning::Course::LearningMaterial.where(:op_lession_id => session.lession_id).to_a
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
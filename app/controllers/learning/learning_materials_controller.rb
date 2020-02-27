module Learning
  class LearningMaterialsController < ApplicationController
    include Rails.application.routes.url_helpers

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

    def test_send_pdf_data
      @learning_material = Learning::Course::LearningMaterial.find(7)
      send_data @learning_material.material_file, type: @learning_material.material_file.content_type, disposition: 'inline'
    end
  end
end
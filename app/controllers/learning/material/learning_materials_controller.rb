class Learning::Material::LearningMaterialsController < ApplicationController
  def find_learning_material
    learning_material = Learning::Material::LearningMaterial.where(id: params[:learning_material_id]).first

    respond_to do |format|
      format.html
      format.js { render '', locals: { learning_material: learning_material }}
    end
  end
end

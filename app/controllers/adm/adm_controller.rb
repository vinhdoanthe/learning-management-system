class Adm::AdmController < ApplicationController
  before_action :validate_admin!

  private
  def validate_admin!
    unless current_user && (current_user.is_admin? || current_user.is_content_admin? || current_user.is_operation_admin?)
      flash[:danger] = "You do not have permission to do this action"
      redirect_to root_path
    end
  end
end

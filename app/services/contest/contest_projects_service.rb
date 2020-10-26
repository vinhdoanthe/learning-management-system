class Contest::ContestProjectsService
  def marking_project params
    binding.pry
    c_project = Contest::ContestProject.where(id: params[:id]).first
    return { type: 'danger', message: 'san pham k ton tai hoac da bi xoa' } if c_project.blank?

    if c_project.update(judges_score: params[:point])
      { type: 'success', message: 'cham diem thanh cong' }
    else
      { type:'danger', message: 'da co loi xay ra! thu lai sau' }
    end
  end
end

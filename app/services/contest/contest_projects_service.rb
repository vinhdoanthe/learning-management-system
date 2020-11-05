class Contest::ContestProjectsService
  def marking_project params
    #binding.pry
    c_project = Contest::ContestProject.where(id: params[:id]).first
    return { type: 'danger', message: 'san pham k ton tai hoac da bi xoa' } if c_project.blank?

    if c_project.update(judges_score: params[:point])
      { type: 'success', message: 'cham diem thanh cong' }
    else
      { type:'danger', message: 'da co loi xay ra! thu lai sau' }
    end
  end

  def update_project_criterion project, data
    like_criterion = project.project_criterions.joins(:contest_criterion).where(tk_contest_criterions: { name: 'like' }).first
    share_criterion = project.project_criterions.joins(:contest_criterion).where(tk_contest_criterions: { name: 'share' }).first
    like = data['engagement']['reaction_count']
    share = data['engagement']['share_count']
    l_criterion = like_criterion.contest_criterion
    s_criterion = share_criterion.contest_criterion
    like_criterion.update(number: like, point_exchange: like.to_i * l_criterion.point)
    share_criterion.update(number: share, point_exchange: share.to_i * s_criterion.point)
  end
end

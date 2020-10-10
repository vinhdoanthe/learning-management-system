class Adm::Contest::ContestsService

  def update_contest params
    if params[:id].present?
      contest = Contest::Contest.where(id: params[:id]).first
      return { type: 'danger', message: 'Cuộc thi không tồn tại!'} if contest.blank?
    else
      contest = Contest::Contest.new
    end

    contest.name = params[:name]
    contest.description = params[:description]
    contest.is_publish = params[:state].to_boolean

    contest.save!

    if params[:photos].present?
      params[:photos].each do |photo|
        create_contest_image photo, contest
      end
    end

    if params[:id].present?
      { type: 'success', message: 'Cập nhật thành công', contest_id: contest.id }
    else
      { type: 'success', message: 'Thêm cuộc thi thành công', contest_id: contest.id }
    end
  end

  def create_contest_image photo, contest
    #  banner = Contest::ContestBanner.new
    #  banner.contest_id = contest.id
  end

end

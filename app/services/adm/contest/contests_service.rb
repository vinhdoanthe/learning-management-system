class Adm::Contest::ContestsService

  def update_contest params
    if params[:id].present?
      contest = Contest::Contest.where(id: params[:id]).first
      return { type: 'danger', message: 'Cuộc thi không tồn tại!'} if contest.blank?
    else
      contest = Contest::Contest.new
    end

    contest.name                        = params[:name]    
    contest.description                 = params[:description]
    contest.rule_atendance_information  = params[:rule_atendance_information]
    contest.rule_product_description    = params[:rule_product_description]
    contest.rule_submission_entries     = params[:rule_submission_entries]
    
    contest.is_publish = params[:state].to_boolean
    contest.description_1 = params[:description_1]
    contest.description_2 = params[:description_2]
    contest.description_3 = params[:description_3]

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
  end

  def delete_contest params
    contest = Contest::Contest.where(id: params[:id]).first
    return { type: "danger", message: "Cuoc thi khong ton tai" } if contest.blank?

    if contest.contest_projects.present?
      result = { type: 'danger', message: "khong the xoa cuoc thi vi da co san pham du thi" }
    else
      if contest.delete
        result = { type: "success", message: "xoa cuoc thi thanh cong" }
      else
        result = { type: "danger", message: "da co loi xay ra! vui long thu laij sau" }
      end
    end

    result
  end
end

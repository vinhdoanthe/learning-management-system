class Adm::Contest::ContestCriterionsService

  def create_criterion params
    c = Contest::ContestCriterion.new
    c.name = params[:name]
    c.point = params[:point]
    c.description = params[:desciption]

    if c.save
      { type: 'success', message: 'Tao tieu chi danh gia thanh cong', criterion: c }
    else
      { type: 'danger', message: 'Da co loi xay ra! Vui long thu lai sau' }
    end
  end

  def delete_criterion params
    c = Contest::ContestCriterion.where(id: params[:id]).first
    topic = Contest::ContestTopic.where(id: params[:topic_id]).first
    if c.blank?
      { type: 'danger', message: 'Tieu chi k ton tai' }
    else
      if can_delete_topic_criterion? c, topic
        c.delete
        { type: 'success', message: 'Xoa thanh cong', criterion: c }
      else
        { type: 'danger', message: 'khong the xoa vi dang duoc su dung' }
      end
    end
  end

  private

  def can_delete? criterion
    Contest::ProjectCriterion.where(criterion_id: criterion.id).first.present?
  end

  def can_delete_topic_criterion? criterion, topic
    Contest::ContestTopicCriterion.where(contest_topic_id: topic.id, contest_criterion_id: criterion.id).first.present?
  end
end

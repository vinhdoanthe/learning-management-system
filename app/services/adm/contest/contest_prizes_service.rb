class Adm::Contest::ContestPrizesService
  def prepare_create contest_id
    contest = Contest::Contest.where(id: contest_id).first
    prizes = if contest.present?
               contest.contest_prizes
             else
               []
             end
    option = ''
    prize = Contest::ContestPrize.new

    { contest: contest, prizes: prizes, option: option, prize: prize }
  end

  def create params
    contest = Contest::Contest.where(id: params[:contest_id]).first
    if can_create? contest, params
      atts = [:contest_id, :name, :student_price, :teacher_price, :prize_type, :month_active, :contest_id, :description, :number_awards, :prize]
      create_params = {}
      atts.each do |att|
        create_params.merge! ({ att => params[att]}) if params[att].present?
      end

      prize = Contest::ContestPrize.new(create_params)
      prizes = contest.contest_prizes.where(prize_type: 'm')

      if prize.save
        { result: { type: 'success', message: 'Thêm giải thưởng thành công'}, prize: prize, contest: contest, prizes: prizes }
      else
        { result: { type: 'danger', message: "Đã có lỗi xảy ra! Vui lòng thử lại sau!"} }
      end
    else
      { result: { type: 'danger', message: 'Giải thưởng cho tháng này đã tồn tại' } }
    end
  end

  private

  def can_create? contest, params
    return true if params[:prize_type] != 'm'
    result = true

    months = contest.contest_prizes.where(prize: params[:prize]).pluck(:month_active)

    if months.blank?
      return true
    else
      months.flatten!.uniq
      months.each do |m|
        result = false if params[:month_active].include? m.to_s
      end
    end

    result
  end
end

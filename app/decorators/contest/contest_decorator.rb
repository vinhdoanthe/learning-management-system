class Contest::ContestDecorator < SimpleDelegator

  def display_month_active
    months = contest_prizes.pluck(:month_active).uniq
    months.flatten!
    display = '<label>Choose month</label>'

    for i in 1..12
      if months.include? (i.to_s)
        display += "<div class='form-check'>
            <input class='form-check-input' id='contest_prize_month_#{ i.to_s }' value='#{ i.to_s }' type='checkbox' name='contest_prize_month[]'>
            <label for='contest_prize_month_#{ i.to_s }'>#{ i.to_s }</label>
          </div>"
      else
        display += "<div class='form-check'>
            <input class='form-check-input' id='contest_prize_month_#{ i.to_s }' value='#{ i.to_s }' type='checkbox' name='contest_prize_month[]'>
            <label for='contest_prize_month_#{ i.to_s }'>#{ i.to_s }</label>
          </div>"
      end
    end

    display
  end

  def display_like_share
    like = project_criterions.joins(:contest_criterion).where(tk_contest_criterions: { name: 'like' }).first&.number
    share = project_criterions.joins(:contest_criterion).where(tk_contest_criterions: { name: 'share' }).first&.number
    "<li><i class='icon16-like'></i><span>#{ like.to_i }</span></li>
    <li><i class='icon16-share'></i><span>#{ share.to_i }</span></li>
    <li><i class='icon16-eye'></i><span>#{ views.to_i }</span></li>"
  end
end

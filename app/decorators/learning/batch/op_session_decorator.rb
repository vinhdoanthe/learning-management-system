class Learning::Batch::OpSessionDecorator < SimpleDelegator
  def display_session_time
    "<b>#{start_datetime.strftime('%H:%M')}</b> #{I18n.t('datetime.to')}  <b>#{end_datetime.strftime('%H:%M')}</b> | <b>#{I18n.t('date.day_names')[start_datetime.to_date.wday]}, #{start_datetime.day}/#{start_datetime.month}/#{start_datetime.year}</b>"     
  end

  def display_tooltip_session_timeline
    if start_datetime < Time.now
      "#{ I18n.t('teacher_class.pass_session')} <br> #{ start_datetime.strftime('%H:%M | %d/%m/%Y') }"
    else
      "#{ I18n.t('teacher_class.coming_session')} <br> #{ start_datetime.strftime('%H:%M | %d/%m/%Y') }"
    end
  end
end

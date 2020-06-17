class Learning::Batch::OpSessionDecorator < SimpleDelegator
  def display_name
    
  end
  
  def display_session_time
    "<b>#{start_datetime.strftime('%H:%M')}</b> #{I18n.t('datetime.to')}  <b>#{end_datetime.strftime('%H:%M')}</b> | <b>#{I18n.t('date.day_names')[start_datetime.to_date.wday]}, #{start_datetime.day}/#{start_datetime.month}/#{start_datetime.year}</b>"     
  end
end

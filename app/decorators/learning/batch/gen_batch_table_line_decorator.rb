class Learning::Batch::GenBatchTableLineDecorator < SimpleDelegator

  def display_timing
    index = day.to_i + BatchConstants::TimeTableLine::DECORATOR_OFFSET_WEEKDAY
    index = index % 7 
    "#{timing.name} #{I18n.t('date.day_names')[index].capitalize}"
  end

end

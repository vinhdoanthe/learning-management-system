class Learning::Batch::GenBatchTableLineDecorator < SimpleDelegator

  def display_timing
    "#{timing.name} #{I18n.t('date.day_names')[day.to_i + BatchConstants::TimeTableLine::DECORATOR_OFFSET_WEEKDAY].capitalize}"
  end

end

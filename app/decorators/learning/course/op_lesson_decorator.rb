class Learning::Course::OpLessonDecorator < SimpleDelegator
  def display_lesson_with_subject
    if !op_subject.nil?
      "#{I18n.t('learning.lesson')} #{lession_number} - #{I18n.t('learning.subject')} #{op_subject.level}"
    else
      "#{I18n.t('learning.lesson')} #{lession_number}"
    end
  end

  def display_lesson_full_name_with_subject
    if !op_subject.nil?
      "#{I18n.t('learning.subject').upcase} #{op_subject.level}: #{name}"
    else
      "#{name}"
    end
  end
end

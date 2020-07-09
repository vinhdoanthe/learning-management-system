class Learning::Batch::OpStudentCourseDecorator < SimpleDelegator
  def display_register_subject
    total_subject = op_course.op_subjects.count
    registered_subject = op_subjects.count
    "#{I18n.t('learning.batch.op_student_course.registered_subject', count_registered_subjects: registered_subject, count_total_subjects: total_subject)}"
  end

  def display_batch_type
    batch_type = op_batch.op_batch_type
    if batch_type.nil?
      ''
    else
      batch_type.name
    end
  end
end

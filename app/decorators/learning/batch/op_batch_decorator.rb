class Learning::Batch::OpBatchDecorator < SimpleDelegator
  def display_weekly_timing
    return_str = ''
    if gen_batch_table_lines.empty?
      return_str = I18n.t('learning.batch.timing.weekly').capitalize
    else
      lines = gen_batch_table_lines.sort_by {|line| line.day}
      timings_str_arr = lines.map {|line| Learning::Batch::GenBatchTableLineDecorator.new(line).display_timing}    
      return_str = "#{timings_str_arr.join(', ')} #{I18n.t('learning.batch.timing.weekly')}"
    end

    "#{return_str} #{I18n.t('learning.batch.at').capitalize}"
  end

  def display_weekly_timing_without_center
    return_str = ''
    if gen_batch_table_lines.empty?
    else
      lines = gen_batch_table_lines.sort_by {|line| line.day}
      timings_str_arr = lines.map {|line| Learning::Batch::GenBatchTableLineDecorator.new(line).display_timing}    
      return_str = timings_str_arr.join(', ')
      return_str += " #{I18n.t('learning.batch.timing.weekly')}"
    end

    return_str
  end

  def display_last_done_session
    session  = op_sessions.where(batch_id: self.id, state: Learning::Constant::Batch::Session::STATE_DONE).last
    if session.nil?
      str = 'Chưa có buổi học nào diễn ra'
    else
      if session.op_subject.nil?
        str = "<a href='/user/open_educat/op_teacher/teacher_class_detail?batch_id=#{ id.to_s }'>" + session.count.to_s + "</a>" + 'Đang cập nhật Subject'
      else
        str = "<a href='/user/open_educat/op_teacher/teacher_class_detail?batch_id=#{ id.to_s }'>" + session.count.to_s + "</a>" + ' - Level ' + session.op_subject.level.to_s
      end
    end

    str
  end
end

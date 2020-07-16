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
end

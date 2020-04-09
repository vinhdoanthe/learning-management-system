namespace :mapping do
  desc 'Mapping Done session with Lesson'
  task :mapping_all_done_session_to_lesson, [] => :environment do |t, args|
    done_sessions = Learning::Batch::OpSession.where(state: Learning::Constant::Batch::Session::STATE_DONE)
    total_count = done_sessions.length()
    count = 0
    unless done_sessions.blank?
      done_sessions.each do |session|
        count += 1
        if (count%100 == 0)
          puts "#{count}/#{total_count}"
        end
        att_sheet = session.op_attendance_sheets.pluck(:lession_id)
        unless att_sheet.blank?
          session.lession_id = att_sheet[-1]
          session.save
        end
      end
    end
  end
end

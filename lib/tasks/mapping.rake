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

  desc 'Mapping lesson to done sessions and assign homework with start_datetime'
  task :mapping_lesson_to_done_session_and_assign_homework, [:previous_days] => :environment do |t, args|
    previous_days = args[:previous_days].to_i
    if previous_days
      prev_seconds = previous_days*24*60*60
      start_datetime = Time.now() - prev_seconds
      done_sessions = Learning::Batch::OpSession.where("state = ? AND start_datetime >= ?", Learning::Constant::Batch::Session::STATE_DONE, start_datetime)
      total_count = done_sessions.length()
      count = 0
      puts total_count
      unless done_sessions.blank?
        done_sessions.each do |session|
          # Mapping
          count += 1
          if (count%100 == 0)
            puts "#{count}/#{total_count}"
          end
          if session.lession_id.blank?
            att_sheet = session.op_attendance_sheets.last
            unless att_sheet.nil?
              session.update(lession_id: att_sheet.lession_id) if !att_sheet.lession_id.blank?
            end
          end
          if !session.lession_id.blank? and !session.batch_id.blank?
            # Assign homework
            student_ids = Learning::Batch::OpStudentCourse.where(batch_id: session.batch_id).pluck(:student_id)
            if !student_ids.blank?
              student_ids.each do |student_id|
                Learning::Homework::QuestionService.new.assign_homework(student_id, session.lession_id, session.id)
              end
            end
          end
        end
      end
    else
      puts "Undefined previous days"
    end
  end
  
  desc 'Mapping old session photos'
  task :mapping_old_session_photos, [] => :environment do |t, args|
     # Find all attachment attached to sessions
    old_attachment_ids = ActiveStorage::Attachment.where(record_type: "Learning::Batch::OpSession").pluck(:id)
    total_count = old_attachment_ids.size
    puts total_count
    count = 0
    old_attachment_ids.each do |old_attachment_id|
      count = count + 1
      puts count
      old_attachment = ActiveStorage::Attachment.where(id: old_attachment_id).first
      next if old_attachment.nil?
      next if !old_attachment.content_type.include?('image')
      session_id = old_attachment.record_id
      session = Learning::Batch::OpSession.where(id: session_id).first
      next if session.nil?
      photo = SocialCommunity::Photo.new
      photo.session_id = session_id
      batch_id = session.batch_id
      next if batch_id.nil?
      user = User::Account::User.where(faculty_id: session.faculty_id).first
      next if user.nil?
      user_id = user.id
      album = SocialCommunity::Album.where(batch_id: batch_id).first
      if album.nil?
        album = SocialCommunity::Album.new
        album.batch_id = batch_id
        album.save
      end
      photo.album_id = album.id
      photo.created_by = user_id
      photo.save
      old_attachment.name = 'image'
      old_attachment.record_type = 'SocialCommunity::Photo'
      old_attachment.record_id = photo.id
      old_attachment.save
    end
    #
  end
end

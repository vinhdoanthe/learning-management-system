module Api

  # @version 1.0: Update directly to DB
  # TODO: in next version: update by calling API from oDoo
  class Odoo
    require 'xmlrpc/client'
    require 'pp'

    # attr_accessor :odoo_url, :odoo_db, :odoo_username, :odoo_password
    @@odoo_url = Settings.odoo['url'] + '/xmlrpc/2/common'
    @@odoo_db = Settings.odoo['db']
    @@odoo_username = Settings.odoo['username']
    @@odoo_password = Settings.odoo['password']

    def self.checkin(session_id:, faculty_id:, check_in_time:)
      errors = validate_before_checkin(session_id, faculty_id, check_in_time)
      if errors.empty?
        session = Learning::Batch::OpSession.find(session_id)
        session.check_in_time = check_in_time
        if check_in_time <= session.start_datetime
          session.check_in_state = Learning::Constant::Batch::Session::CHECKIN_STATE_GOOD
        else
          session.check_in_state = Learning::Constant::Batch::Session::CHECKIN_STATE_BAD
        end
        session.save
        if session.errors.full_messages.any?
          return session.errors.full_messages.to_s
        end
      else
        return errors
      end
    end

    def self.attendance(session_id:, faculty_id:, attendance_time:, attendance_lines:)
      errors = validate_before_attendance(session_id, faculty_id, attendance_time, attendance_lines)
      if errors.nil?
        session = Learning::Batch::OpSession.find(session_id)
        # Step 1: Create Attendance Sheet
        lesson = session.op_lession
        attendance_sheet = Learning::Batch::OpAttendanceSheet.find_or_create_by(session_id: session_id, faculty_id: faculty_id)
        # attendance_sheet.session_id = session.id
        attendance_sheet.lession_id = session.lession_id
        attendance_sheet.name = lesson.name
        attendance_sheet.note = lesson.note
        attendance_sheet.course_id = session.course_id
        attendance_sheet.attendance_date = attendance_time.to_date
        attendance_sheet.batch_id = session.batch_id
        # attendance_sheet.faculty_id = faculty_id
        # attendance_sheet.create_uid
        # attendance_sheet.create_date
        # attendance_sheet.write_date
        # attendance_sheet.write_uid
        # attendance_sheet.tutors_id = session.tutors_id
        attendance_sheet.company_id = session.company_id
        attendance_sheet.subject_id = session.subject_id
        if session.end_datetime + 1.day > attendance_time
          attendance_sheet.state = '1'
        elsif session.end_datetime + 2.days > attendance_time
          attendance_sheet.state = '0'
        else
          attendance_sheet.state = '-1'
        end

        attendance_sheet.save
        if attendance_sheet.errors.full_messages.any?
          errors << attendance_sheet.errors.full_messages.to_s
          #TODO : should rollback here?
        end
        if errors.nil?
          # Create Attendance Lines
          unless attendance_lines.blank?
            attendance_lines.each do |att_line|
              if att_line[:student_id].nil? || att_line[:is_present].nil?
                errors << 'Một trong các attendance lines bị lỗi'
              else
                op_att_line = Learning::Batch::OpAttendanceLine.find_or_create_by(student_id: att_line[:student_id], session_id: session_id,
                                                                                  attendance_id: attendance_sheet.id)
                op_att_line.company_id = session.company_id
                # op_att_line.attendance_id = attendance_sheet.id
                # op_att_line.student_id = att_line[:student_id]
                op_att_line.present = att_line[:is_present]
                op_att_line.course_id = session.course_id
                op_att_line.batch_id = session.batch_id
                op_att_line.attendance_date = attendance_sheet.attendance_date
                # op_att_line.session_id = session.id
                op_att_line.note = att_line[:note] unless att_line[:note].blank?

                op_att_line.save
                if op_att_line.errors.full_messages.any?
                  errors << op_att_line.errors.full_messages.to_s
                  #TODO : should rollback here
                end
              end
            end
          end
        end
      end
      errors
    end

    private

    def self.odoo_xml_authenticate
      common = XMLRPC::Client.new2(@@odoo_url)
      common.call('authenticate', @@odoo_db, @@odoo_username, @@odoo_password, {})
    end

    def self.validate_before_checkin(session_id, faculty_id, check_in_time)
      errors = []
      # TODO: mã hóa err code
      if session_id.nil? || faculty_id.nil? || check_in_time.nil?
        errors << 'Thông tin không đúng. Đã có lỗi xảy ra'
      else
        session = Learning::Batch::OpSession.find(session_id)
        if session.nil?
          errors << 'Không tìm thấy buổi học tương ứng'
        else
          if session.state != Learning::Constant::Batch::Session::STATE_CONFIRM && session.state != Learning::Constant::Batch::Session::STATE_CONFIRM
            errors << 'Buổi học chưa được confirm'
          end
          if session.start_datetime - Learning::Constant::Batch::Session::MINUTES_BEFORE_ALLOW_CHECKIN.minutes > check_in_time
            errors << 'Chỉ được checkin trước buổi học 15 phút'
          end
          if session.end_datetime < check_in_time
            errors << 'Buổi học đã kết thúc'
          end
          if session.faculty_id.nil? or session.faculty_id != faculty_id
            errors << 'Thông tin giảng viên không khớp'
          end
        end
      end
      errors
    end

    def self.validate_before_attendance(session_id, faculty_id, attendance_time, attendance_lines)
      errors = []
      if session_id.nil? || faculty_id.nil? || attendance_time.nil? || attendance_lines.blank?
        errors << 'Thông tin không đúng. Đã có lỗi xảy ra'
      else
        session = Learning::Batch::OpSession.find(session_id)
        if session.nil?
          errors << 'Không tìm thấy buổi học tương ứng'
        else
          if session.state != Learning::Constant::Batch::Session::STATE_CONFIRM
            errors << 'Buổi học chưa được chuyển trạng thái Done'
          end
          if session.faculty_id.nil? or session.faculty_id != faculty_id
            errors << 'Thông tin giảng viên không khớp'
          end
          if attendance_time < session.start_datetime
            errors << 'Chưa đến giờ bắt đầu buổi học'
          end
          lesson = session.op_lession
          if lesson.nil?
            errors << 'Không tìm thấy lesson tương ứng'
          end
        end
      end
    end
  end
end
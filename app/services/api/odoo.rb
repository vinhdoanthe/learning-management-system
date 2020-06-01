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

    def self.odoo_xml_authenticate
        common = XMLRPC::Client.new2(@@odoo_url)
        uid = common.call('authenticate', @@odoo_db, @@odoo_username, @@odoo_password, {})
        models = XMLRPC::Client.new2(Settings.odoo['url'] + '/xmlrpc/2/object').proxy
        return uid, models
      end

    def self.checkin(session_id:, faculty_id:, check_in_time:)
        errors = validate_before_checkin(session_id, faculty_id, check_in_time)
        if errors.empty?
            uid, models = odoo_xml_authenticate()
            begin
                success, mes = models.execute_kw(@@odoo_db, uid, @@odoo_password,
                        'op.session', 'check_in_lms',
                        [session_id], {})
                return success, mes
            rescue => exception
                return false, exception
            end
        else
            return false, errors
        end
    end

    def self.test()
        evaluate(session_id: 116423, faculty_id: 3103, attendance_time: 0, attendance_lines: [{student_id: 14413, knowledge1: '1'}])
    end
    
    #attendance_lines = [{student_id: 14413, state_evaluate: '1', knowledge1: '1'}]
    def self.attendance(session_id:, faculty_id:, lession_id:, attendance_time:, attendance_lines:)
        errors = validate_before_attendance(session_id, faculty_id, attendance_time, attendance_lines)
        if errors.empty?
            uid, models = odoo_xml_authenticate()
            begin
                id = models.execute_kw(@@odoo_db, uid, @@odoo_password, 'op.attendance.sheet', 'create', [{
                    session_id: session_id,
                    faculty_id: faculty_id,
                    lession_id: lession_id,
                    attendance_line: attendance_lines.map{|x| [0,0,x]}
                }])
                return id
            rescue => exception
                return false, exception
            end

        else
            return errors
        end

    end

    def self.evaluate(session_id:, faculty_id:, attendance_time:, attendance_lines:)
        #errors = validate_before_attendance(session_id, faculty_id, attendance_time, attendance_lines)
        errors = []
        if errors.empty?
            uid, models = odoo_xml_authenticate()
            begin
                id = models.execute_kw(@@odoo_db, uid, @@odoo_password, 'op.attendance.sheet', 'evaluate_lms', [{
                    session_id: session_id,
                    attendance_line: attendance_lines.map{|x| [0,0,x]}
                }])
                return id
            rescue => exception
                return false, exception
            end

        else
            return errors
        end

    end

    private

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
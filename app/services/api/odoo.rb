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
          # flash.now[:danger] = session.errors.full_messages.to_s
        end
      else
        return errors
        # flash.now[:danger] = errors
      end
    end

    def self.attendance(op_student_id:, session_id:, **args)
      # TODO: implement here
      uid = self.authenticate
      if uid

      else
        # TODO: raise errors here
      end
    end

    private

    def self.authenticate
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
  end
end
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

    def self.get_error(exception)
      re = /(ValidationError\()(".*")(\))/
      match = exception.faultString.scan(re)
      if match.length > 0 and match[0].length > 1
        msg = match[0][1]
        msg.gsub!('"', "")
        return msg
      end
      return ''
    end

    def self.odoo_xml_authenticate
      common = XMLRPC::Client.new2(@@odoo_url)
      uid = common.call('authenticate', @@odoo_db, @@odoo_username, @@odoo_password, {})
      models = XMLRPC::Client.new2(Settings.odoo['url'] + '/xmlrpc/2/object').proxy
      return uid, models
    end

    def self.checkin(session_id:, faculty_id:, check_in_time:)
      uid, models = odoo_xml_authenticate()
      begin
        success, mes = models.execute_kw(@@odoo_db, uid, @@odoo_password,
                                         'op.session', 'check_in_lms',
                                         [session_id], {})
        return success, mes
      rescue XMLRPC::FaultException => exception
        return false, exception
      end
    end

    def self.test()
      attendance(session_id: 116423, faculty_id: 3103, lession_id: 834, attendance_time: 0, attendance_lines: [{student_id: 14413, present: true}])
      #evaluate(session_id: 116423, faculty_id: 3103, attendance_time: 0, attendance_lines: [{student_id: 14413, knowledge1: '1'}])
    end

    #attendance_lines = [{student_id: 14413, state_evaluate: '1', knowledge1: '1'}]
    def self.attendance(session_id:, faculty_id:, lession_id:, attendance_time:, attendance_lines:)
      uid, models = odoo_xml_authenticate()
      begin        
        id = models.execute_kw(@@odoo_db, uid, @@odoo_password, 'op.attendance.sheet', 'create', [{
          session_id: session_id,
          faculty_id: faculty_id,
          lession_id: lession_id,
          attendance_line: attendance_lines.map{|x| [0,0,x]}
        }])
        return id
      rescue XMLRPC::FaultException => exception            
        return false, get_error(exception)
      end
    end

    def self.evaluate(session_id:, faculty_id:, attendance_time:, attendance_lines:)
      uid, models = odoo_xml_authenticate()

      begin
        id = models.execute_kw(@@odoo_db, uid, @@odoo_password, 'op.attendance.sheet', 'evaluate_lms', [{
          session_id: session_id,
          attendance_line: attendance_lines.map{|x| [0,0,x]}
        }])
        return id
      rescue XMLRPC::FaultException => exception            
        return false, get_error(exception)
      end

    end

  end
end

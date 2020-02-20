module Api
  class Odoo
    require 'xmlrpc/client'
    require 'pp'

    # attr_accessor :odoo_url, :odoo_db, :odoo_username, :odoo_password
    @@odoo_url = Settings.odoo['url'] + '/xmlrpc/2/common'
    @@odoo_db = Settings.odoo['db']
    @@odoo_username = Settings.odoo['username']
    @@odoo_password = Settings.odoo['password']

    def self.checkin(**args)
      uid = self.authenticate
      if uid
        p "Authenticate success!"
      else
        p "Authenticate failed!"
        # TODO: raise errors here
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
  end
end
class SendGridMailer
  require 'sendgrid-ruby'
  include EmailConstants

  attr_accessor :sendgrid

  def initialize 
    @sendgrid = SendGrid::API.new(api_key: Settings.sendgrid[:api_key])
  end

  def send_email type, data
    if type == MailType::SEND_FACULTY_ACCOUNT_INFORMATION
      send_faculty_account_email data 
    else
    end
  end

  private

  def parse_faculty_account_data teacher_user
    data = {
      :email => teacher_user.email,
      :faculty_name => teacher_user.full_name,
      :username => teacher_user.username,
      :password => Settings.user.faculty[:default_password]
    } 
    {
      "personalizations": [
        {
          "to": [
            {
              "email": data[:email]
            }
          ],
          "dynamic_template_data": {
            "faculty_name": data[:faculty_name],
            "username": data[:username],
            "password": data[:password]
          }
        }
      ],
      "from": {
        "email": Settings.sendgrid[:from_email]
      },
      "template_id": Settings.sendgrid.template[:send_faculty_account]
    }
  end

  def send_faculty_account_email data
    data = parse_faculty_account_data(data)
    begin
      response = @sendgrid.client.mail._('send').post(request_body: data)
      return response
    rescue Exception => e
      puts e.message
    end
  end
end

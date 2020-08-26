class SendGridMailer
  require 'sendgrid-ruby'
  include EmailConstants
  include Rails.application.routes.url_helpers

  attr_accessor :sendgrid

  def initialize 
    @sendgrid = SendGrid::API.new(api_key: Settings.sendgrid[:api_key])
  end

  def send_email type, data
    binding.pry
    if type == MailType::SEND_FACULTY_ACCOUNT_INFORMATION
      send_faculty_account_email data 
    elsif type == MailType::SEND_RESET_PASSWORD_EMAIL
      send_reset_password_email data
    elsif type == MailType::SEND_REFER_FRIEND_CONFIRM_EMAIL
      send_refer_friend_email data
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
        "email": Settings.sendgrid.from[:email],
        "name": Settings.sendgrid.from[:name]
      },
      "template_id": Settings.sendgrid.template[:send_faculty_account]
    }
  end

  def parse_reset_password_data user
    {
      "personalizations": [
        {
          "to": [
            {
              "email": user.email_address_for_sending
            }
          ],
          "dynamic_template_data": {
            "full_name": user.full_name,
            "username": user.username,
            "reset_link": edit_user_account_password_reset_url(user.reset_token, username: user.username), 
            "expire_after_hours": Settings.user.password[:expire_after_hours]
          }
        }
      ],
      "from": {
        "email": Settings.sendgrid.from[:email],
        "name": Settings.sendgrid.from[:name]
      },
      "template_id": Settings.sendgrid.template[:send_reset_password]
    }
  end

  def send_faculty_account_email teacher_user
    data = parse_faculty_account_data(teacher_user)
    execute_send(data)
  end

  def send_reset_password_email user
    data = parse_reset_password_data(user)
    execute_send(data)
  end

  def send_refer_friend_email data
    # data:
    # parent_email
    # parent_name
    # refer_person_name
    # confirm_url
    # discard_url
    # expired_after_hours
    refer_friend_data = {
      "personalizations": [
        {
          "to": [
            {
              "email": data[:parent_email]
            }
          ],
          "dynamic_template_data": {
            "parent_name": data[:parent_name],
            "refer_person_name": data[:refer_person_name],
            "confirm_url": data[:confirm_url],
            "discard_url": data[:discard_url], 
            "expire_after_hours": data[:expire_after_hours]
          }
        }
      ],
      "from": {
        "email": Settings.sendgrid.from[:email],
        "name": Settings.sendgrid.from[:name]
      },
      "template_id": Settings.sendgrid.template[:send_refer_friend_confirm]
    }

    execute_send refer_friend_data
  end

  def execute_send data
    begin
      response = @sendgrid.client.mail._('send').post(request_body: data)
      return response
    rescue Exception => e
      puts e.message
    end
  end
end

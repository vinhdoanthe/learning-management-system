class SendGridMailer
  require 'sendgrid-ruby'
  include EmailConstants
  include Rails.application.routes.url_helpers

  attr_accessor :sendgrid

  def initialize 
    @sendgrid = SendGrid::API.new(api_key: Settings.sendgrid[:api_key])
  end

  def send_email type, data
    if type == MailType::SEND_FACULTY_ACCOUNT_INFORMATION
      send_faculty_account_email data 
    elsif type == MailType::SEND_RESET_PASSWORD_EMAIL
      send_reset_password_email data
    elsif type == MailType::SEND_REFER_FRIEND_CONFIRM_EMAIL
      send_refer_friend_email data
    elsif type == MailType::SEND_CLAIM_EMAIL_NOTI
      send_claim_email_noti data
    elsif type == MailType::SEND_STUDENT_REDEEM_EMAIL
      send_student_redeem_email data
    elsif type == MailType::SEND_ADMIN_REDEEM_EMAIL
      send_admin_redeem_email data
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

  def parse_claim_data claim
    {
      "personalizations": [
        {
          "to": [
            {
              "email": Settings.sendgrid.to[:email]
            }
          ],
          "dynamic_template_data": {
            "claim_type": claim[:type],
            "parent_name": claim[:student_name],
            "student_name": claim[:parent_name],
            "odoo_link": claim[:odoo_url]
          }
        }
      ],
      "from": {
        "email": Settings.sendgrid.from[:email],
        "name": Settings.sendgrid.from[:name]
      },
      "template_id": Settings.sendgrid.template[:send_claim]
    }
  end

  def parse_redeem_data redeem, email, template
    product = redeem.redeem_product
    user = redeem.user

    {
      "personalizations": [
        {
          "to": [
            {
              "email": email
            }
          ],
          "dynamic_template_data":
          {
            "student_name": user.full_name,
            "product_name": product.name,
            "product_count": redeem.amount.to_i,
            "total_teky_coin": redeem.total_paid.to_i
          }
        }
      ],
      "from": { "email": Settings.sendgrid.from[:email],
                "name": Settings.sendgrid.from[:name]
      },
      "template_id": template
    }
  end

  def send_student_redeem_email redeem
    user = redeem.user
    email = user.email
    status = redeem.status

    if status == RedeemConstants::TransactionState::REDEEM_TRANSACTION_STATE_NEW
      template = Settings.sendgrid.template[:send_student_new_redeem]
    elsif status == RedeemConstants::TransactionState::REDEEM_TRANSACTION_STATE_CANCEL
      template = Settings.sendgrid.template[:send_student_cancel_redeem]
    elsif status == RedeemConstants::TransactionState::REDEEM_TRANSACTION_STATE_DONE
      template = Settings.sendgrid.template[:send_student_done_redeem]
    end

    data = parse_redeem_data redeem, email, template

    if redeem.status == RedeemConstants::TransactionState::REDEEM_TRANSACTION_STATE_CANCEL
      data[:personalizations][0][:dynamic_template_data].merge!({ cancel_reason: "S???n ph???m b???n ?????i ???? h???t " })
    end

    execute_send(data)
  end

  def send_admin_redeem_email redeem
    email = Settings.sendgrid.to[:redeem_email]
    template = Settings.sendgrid.template[:send_admin_redeem]
    data = parse_redeem_data redeem, email, template

    if Rails.env.development?
      request_link = "http://stagging.lms.teky.vn/"
    else
      request_link = "https://lms.teky.online/"
    end

    request_link += "adm/redeem/redeem_transactions/show/#{ redeem.id }"
    data[:personalizations][0][:dynamic_template_data].merge!({request_link: request_link })

    execute_send(data)
  end

  def send_claim_email_noti data
    data = parse_claim_data(data)
    execute_send(data)
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

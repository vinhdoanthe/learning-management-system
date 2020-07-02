namespace :email do
  desc 'Send faculty account email'
  task :send_faculty_account_email, [:user_id] => :environment do |t, args|
    if args[:user_id] == 0
      # send to all faculty users
    else
      user = User::Account::User.where(id: args[:user_id].to_i).first
      unless user.nil?
        puts user.full_name
        SendGridMailer.new.send_email(EmailConstants::MailType::SEND_FACULTY_ACCOUNT_INFORMATION, user)
        puts 'send_faculty_account_email done'
      end
    end  
  end
end

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def coin_star_setting
    if self.class.to_s == 'Learning::Batch::SessionStudentFeedback'
      User::Reward::TekyCoinStarActivitySetting.where(setting_key: User::Constant::TekyCoinStarActivitySetting::FEED_BACK).first
    elsif self.class.to_s == 'Learning::Batch::OpAttendanceLine'
      User::Reward::TekyCoinStarActivitySetting.where(setting_key: User::Constant::TekyCoinStarActivitySetting::ATTENDANCE_YES).first
    elsif self.class.to_s == 'Learning::Batch::SessionStudentReward'
      case reward_type_id
      when 1
        User::Reward::TekyCoinStarActivitySetting.where(setting_key: User::Constant::TekyCoinStarActivitySetting::REWARD_LVN).first
      when 2
        User::Reward::TekyCoinStarActivitySetting.where(setting_key: User::Constant::TekyCoinStarActivitySetting::REWARD_GB).first
      when 3
        User::Reward::TekyCoinStarActivitySetting.where(setting_key: User::Constant::TekyCoinStarActivitySetting::REWARD_TCPB).first
      when 4
        User::Reward::TekyCoinStarActivitySetting.where(setting_key: User::Constant::TekyCoinStarActivitySetting::REWARD_LBTL).first
      end
    elsif self.class.to_s == 'Learning::Homework::UserAnswer'
      if self.question_choice_id.blank?
        User::Reward::TekyCoinStarActivitySetting.where(setting_key: User::Constant::TekyCoinStarActivitySetting::HOMEWORK_TEXT).first
      else
        User::Reward::TekyCoinStarActivitySetting.where(setting_key: User::Constant::TekyCoinStarActivitySetting::HOMEWORK_CHOICE).first
      end
    elsif self.class.to_s == 'SocialCommunity::ScStudentProject'
      User::Reward::TekyCoinStarActivitySetting.where(setting_key: User::Constant::TekyCoinStarActivitySetting::UPLOAD_SPCK).first
    end
  end
end

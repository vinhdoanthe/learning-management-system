class User::Reward::CoinStarTransactionDecorator < SimpleDelegator
  def display_content
    if __getobj__.nil?
      ''
    else
      if coinstarable_id.blank?
        return  "#{I18n.t('reward.you_were_reward')} #{amount} #{I18n.t('reward.star')}"
      end

      str = ''
      if transaction_type == RewardConstants::Type::TEKY_STAR 
        str += "#{I18n.t('reward.you_were_reward')} #{amount} #{I18n.t('reward.star')} #{I18n.t('reward.because')} "
      elsif transaction_type == RewardConstants::Type::TEKY_COIN
        str += "#{I18n.t('reward.you_were_reward')} #{amount} #{I18n.t('reward.coin')} #{I18n.t('reward.because')} "
      end

      case coinstarable.class.to_s
      when "Learning::Batch::SessionStudentFeedback"
        str += "#{I18n.t('reward.feedback')} #{ I18n.t('reward.course') } #{ coinstarable.op_session&.name}"
      when "Learning::Batch::SessionStudentReward"
        str += "#{I18n.t('reward.reward')}  #{ I18n.t('reward.course') } #{ coinstarable.op_session&.name}"
      when "Learning::Homework::UserAnswer"
        batch = Learning::Batch::OpBatch.where(id: coinstarable.batch_id).first

        if batch.present?
          course = batch.op_course
          course_name = course.present? ? course.name : ''
        else
          ''
        end

        str += "#{I18n.t('reward.do_homework')} #{ I18n.t('reward.course') } #{ course_name }"
      when "Learning::Batch::OpAttendanceLine"
        course = Learning::Course::OpCourse.where(id: coinstarable.course_id).first
        course_name = course.present? ? course.name : ''
        str += "#{ I18n.t('reward.attendance') } #{ I18n.t('reward.course') } #{ course_name }"
      when "SocialCommunity::ScStudentProject"
        str += "#{I18n.t('reward.complete_project')} #{ I18n.t('reward.course')} #{ coinstarable.op_course&.name }"
      when "Redeem::RedeemTransaction"
        product = coinstarable.redeem_product
        product_name = product.present? ? product.name : ''
        str = "#{ I18n.t('reward.you_were_redeem') } #{ product_name }, #{ I18n.t('reward.had_minus')} #{ amount }"
      end
    end

    str
  end
end

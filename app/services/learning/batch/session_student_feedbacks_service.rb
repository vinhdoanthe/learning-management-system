class Learning::Batch::SessionStudentFeedbacksService
  def create_new_feedback params, user
    feedback = Learning::Batch::SessionStudentFeedback.where(session_id: params[:session_id], feedback_by: user.id).first
    return { type: 'danger', message: 'Con đã nhận xét rồi!' } if feedback.present?

    ActiveRecord::Base.transaction do
      feedback = Learning::Batch::SessionStudentFeedback.new
      feedback.session_id = params[:session_id]
      feedback.content = params[:content]
      feedback.feeling_type_id = params[:type]
      feedback.feedback_by = user.id
      feedback.save
      # create noti
      feedback.create_notifications

      { type: 'success', message: 'Cảm ơn con đã nhận xét về buổi học nhé!' }
    end
  rescue StandardError => e
    puts e
    { type: 'danger', message: 'Đã có lỗi xảy ra! Con thử lại sau nhé!' }
  end

  def self.get_subscribed_users session_id
    session = Learning::Batch::OpSession.where(id: session_id).first
    return [] if session.blank?
    User::Account::User.where(faculty_id: session.faculty_id).all
  end
end

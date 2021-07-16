class SocialCommunity::ScStudentProject < ApplicationRecord
  include Rails.application.routes.url_helpers

  extend Enumerize
  self.table_name = 'sc_student_projects'
  paginates_per 20

  enumerize :state, in: [SocialCommunity::Constant::ScStudentProject::State::PUBLISH, SocialCommunity::Constant::ScStudentProject::State::DRAFT]
  enumerize :permission, in: [SocialCommunity::Constant::ScStudentProject::Permission::PUBLIC, SocialCommunity::Constant::ScStudentProject::Permission::PRIVATE]
  enumerize :project_type, in: [SocialCommunity::Constant::ScStudentProject::ProjectType::SESSION_PROJECT, SocialCommunity::Constant::ScStudentProject::ProjectType::SUBJECT_PROJECT]

  belongs_to :user, class_name: 'User::Account::User', foreign_key: 'user_id'
  belongs_to :op_student, class_name: 'User::OpenEducat::OpStudent', foreign_key: 'student_id'
  belongs_to :op_batch, class_name: 'Learning::Batch::OpBatch', foreign_key: 'batch_id'
  belongs_to :op_course, class_name: 'Learning::Course::OpCourse', foreign_key: 'course_id'
  belongs_to :op_subject, class_name: 'Learning::Course::OpSubject', foreign_key: 'subject_id'
  belongs_to :sc_post, class_name: 'SocialCommunity::Feed::StudentProjectPost', foreign_key: 'sc_post_id'
  belongs_to :created_user, class_name: 'User::Account::User', foreign_key: 'created_by', optional: true
  
  has_one_attached :presentation
  has_one_attached :image


  def student_name
    '' if op_student.nil?
    op_student.full_name
  end

  def presentation_link
    if presentation.attached?
      url_for(presentation)
    else
      ''
    end
  end

  def youtube_video_link
    return '' if introduction_video.blank?

    account = Yt::Account.new refresh_token: Settings.youtube['refresh_token']
    video = Yt::Video.new id: introduction_video, auth: account
    embed_link = ''
    begin
      embed_link = video.embed_html
    rescue Yt::Errors::NoItems => error
      Rails.logger.error(error.to_s)
      embed_link = ''
    ensure
    end
  end
end

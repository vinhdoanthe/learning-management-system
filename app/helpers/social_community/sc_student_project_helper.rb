module SocialCommunity
  module ScStudentProjectHelper
    def get_project_progress project
      progress = 0
      attributes = ['project_show_video', 'presentation', 'introduction_video']
      attributes.each{ |att| progress += 1/3.to_f if project.send(att).present? }
      progress * 100
    end

    def check_projects project_hash
      check = []
      check = project_hash.each{ |k,v| check << k if v.present? }
      check.present?
    end

    def student_can_edit_project? project, user
      return false if project.user_id != user.id

      c_project = Contest::ContestProject.where(project_id: project.id).first
      return false if c_project.blank?

      topic = c_project.contest_topic
      return false if topic.blank?

      Time.now > topic.start_time && Time.now < topic.end_time
    end
  end
end

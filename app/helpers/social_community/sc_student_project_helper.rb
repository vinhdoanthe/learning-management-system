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
  end
end

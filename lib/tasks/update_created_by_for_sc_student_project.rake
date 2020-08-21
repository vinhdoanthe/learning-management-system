namespace :update_created_by_for_sc_student_project do
  desc "Update created user for student project"
  task udpate_student_project: :environment do
    projects = SocialCommunity::ScStudentProject.where(created_by: nil)
    count = projects.count
    projects.each_with_index do |project, index|
      post = project.sc_post
      if post.present?
        project.update(created_by: post.posted_by)
        puts "#{ index + 1 }/#{ count }"
      end
    end
  end
end

class SocialCommunity::ScStudentProjectsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def youtube_upload
    if validate_youtube_upload_params params
      account = Yt::Account.new refresh_token: Settings.youtube['refresh_token']
      file = params[:file].try(:tempfile).try(:to_path)
      new_video = account.upload_video file, title: params[:title], description: params[:description]
      video_id = new_video.id
      video = Yt::Video.new id: video_id
      embed_link = video.embed_html
      SocialCommunity::ScStudentProjectsService.new.manage_youtube_playlist account, params[:batch_id], video_id
      SocialCommunity::ScStudentProjectsService.new.create_student_project params, embed_link, current_user
      User::Reward::CoinStarsService.new.reward_coin_star 'UPLOAD_SPCK', params[:student_id], 'coin', current_user.id
      User::Reward::CoinStarsService.new.reward_coin_star 'UPLOAD_SPCK', params[:student_id], 'star', current_user.id
      render json: {message: 'success'}
    else
      render json: {message: 'false'}
    end
  end

  def validate_youtube_upload_params params
    params[:file].present? && params[:title].present? && params[:batch_id].present? && params[:student_id].present? && params[:subject_id].present?
  end

  def student_project_detail
    project = SocialCommunity::ScStudentProject.where(id: params[:project_id]).first
    batch = project.op_batch
    course = project.op_course
    student = project.op_student
    company = student.res_company
    company_name = ''
    company_name = company.name if company.present?

    respond_to do |format|
      format.html
      format.js { render 'user/open_educat/shared/js/student_project_detail', locals: { project: project, batch: batch, course: course, student: student, company_name: company_name}}
    end
  end

  def student_projects
    subject_student_projects = SocialCommunity::ScStudentProject.where(batch_id: params[:batch_id]).all.group_by{ |product| product.subject_id }

    batch = Learning::Batch::OpBatch.where(id: params[:batch_id]).first
    course = batch.op_course
    subjects = course.op_subjects.pluck(:id, :level)
    url = if current_user.is_student?
            'user/open_educat/op_students/js/student_projects'
          else
            'user/open_educat/op_teachers/js/teacher_class_details/student_projects'
          end

    respond_to do |format|
      format.html
      format.js { render url, locals: { subject_student_projects: subject_student_projects, subjects: subjects } }
    end
  end
end

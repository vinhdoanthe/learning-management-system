class SocialCommunity::ScStudentProjectsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def youtube_upload
    user = User::Account::User.where(student_id: params[:student_id]).first
    if validate_youtube_upload_params params
      if params[:file].present? && params[:title].present?
        account = Yt::Account.new refresh_token: Settings.youtube['refresh_token']
        file = params[:file].try(:tempfile).try(:to_path)
        new_video = account.upload_video file, title: params[:title], description: params[:description]
        video_id = new_video.id
        video = Yt::Video.new id: video_id
        embed_link = video.embed_html
        thumbnail_video = video.thumbnail_url

        SocialCommunity::ScStudentProjectsService.new.manage_youtube_playlist account, params[:batch_id], video_id
      else
        embed_link = ''
        thumbnail_video = ''
      end

      SocialCommunity::ScStudentProjectsService.new.create_student_project params, embed_link, current_user, thumbnail_video
      User::Reward::CoinStarsService.new.reward_coin_star 'UPLOAD_SPCK', user.id, 'coin', current_user.id
      User::Reward::CoinStarsService.new.reward_coin_star 'UPLOAD_SPCK', user.id, 'star', current_user.id
      render json: {type: 'success', message: 'Upload thành công'}
    else
      render json: {type: 'danger', message: 'Đã có lỗi xảy ra! Thử lại sau'}
    end
  end

  def validate_youtube_upload_params params
    (params[:batch_id].present? && params[:student_id].present? && params[:subject_id].present?) && ((params[:file].present? && params[:title].present?) || params[:slide].present? || params[:link].present?)
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

  def edit_student_project
    project = SocialCommunity::ScStudentProject.where(id: params[:project_id]).first
    batch = Learning::Batch::OpBatch.where(id: project.batch_id).first
    subject_ids = batch.op_sessions.pluck(:subject_id)
    subjects = Learning::Course::OpSubject.where(id: subject_ids).pluck(:id, :level)
    student = User::OpenEducat::OpStudent.where(id: project.student_id).first
    student_ids = Learning::Batch::OpStudentCourse.where(batch_id: batch.id).pluck(:student_id)
    all_student = User::OpenEducat::OpStudent.where(id: student_ids).pluck(:id, :full_name)

    respond_to do |format|
      format.html
      format.js { render 'user/open_educat/shared/student_projects/js/edit_student_project', locals: { student: student, project: project, subjects: subjects, all_student: all_student } }
    end
  end

  def update_student_project
    list_params = ['name', 'description', 'student_id', 'subject_id', 'state', 'permission']
    return unless current_user.is_teacher?
    project = SocialCommunity::ScStudentProject.where(id: params[:project_id]).first
    update_params = {}
    params.each{|k,v| update_params.merge!({k => v}) if list_params.include? k }
    update_params.select!{ |k, v| v.present? }

    if project.update(update_params)
      render json: { type: 'success', 'message': 'Update thành công' }
    else
      render json: { type: 'danger', 'message': 'Đã có lỗi xảy ra! Thử lại sau' }
    end
  end

  def student_projects
    subject_student_projects = SocialCommunity::ScStudentProject.where(batch_id: params[:batch_id]).all.group_by{ |product| product.subject_id }

    batch = Learning::Batch::OpBatch.where(id: params[:batch_id]).first
    course = batch.op_course
    subjects = course.op_subjects.pluck(:id, :level)
    subjects.sort_by!{|s| s[1]}

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

  def social_student_projects
    data = SocialCommunity::ScStudentProjectsService.new.social_student_projects current_user
    @student_projects = data[0]
    @course_projects = data[1]
  end

  def course_student_projects
    @course = Learning::Course::OpCourse.where(id: params[:course_id]).first
    @course_projects = SocialCommunity::ScStudentProject.where(course_id: params[:course_id], permission: 'public', state: 'publish').page params[:page]
  end
end

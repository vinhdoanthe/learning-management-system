class SocialCommunity::ScStudentProjectsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :handling_params, only: [:create_student_project, :update_student_project]

  def create_student_project
    result = { type: 'danger', message: 'Đã có lỗi xảy ra! Vui lòng thử lại sau!' }
    project = ''
    sc_student_service = SocialCommunity::ScStudentProjectsService.new
    user = User::Account::User.where(student_id: @params[:student_id]).first
    student = user.op_student

    if validate_youtube_upload_params @params
      if @params[:introduction_video].present? && @params[:name].present?
        video_detail = sc_student_service.upload_video_youtube @params[:name], @params[:introduction_video], @params[:description], @params[:batch_id]
        embed_link = video_detail[0]
        thumbnail_video= video_detail[1]
      else
        embed_link = ''
        thumbnail_video = ''
      end

      begin
        project = sc_student_service.create_student_project @params, embed_link, current_user, thumbnail_video
        result = {type: 'success', message: 'Upload thành công'}
      rescue StandardError
        result = { type: 'danger', message: 'Đã có lỗi xảy ra! Vui lòng thử lại sau!' }
      end

     User::Reward::CoinStarsService.new.reward_coin_star project, user.id, current_user.id if user.present?
    else
      result = {type: 'danger', message: 'Thiếu thông tin sản phẩm! Vui lòng kiểm tra lại!'}
    end

    respond_to do |format|
      format.html
      format.js { render 'user/open_educat/shared/student_projects/forms/ajax_response', locals: { result: result, project: project, student: student } }
    end
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
    student = User::Account::User.where(id: project.student_id).first
    detail = batch_student_info project.batch_id
    all_student = detail[1]
    subjects = detail[0]

    respond_to do |format|
      format.html
      format.js { render 'user/open_educat/shared/student_projects/js/edit_student_project', locals: { student: student, project: project, subjects: subjects, all_student: all_student } }
    end
  end

  def prepare_upload_project
    detail = batch_student_info params[:batch_id]
    all_student = detail[1]
    subjects= detail[0]
    batch = detail[2]

    respond_to do |format|
      format.html
      format.js { render 'user/open_educat/shared/student_projects/js/prepare_upload_project', locals: { all_student: all_student, subjects: subjects, batch: batch } }
    end
  end

  def update_student_project
    result = SocialCommunity::ScStudentProjectsService.new.update_student_project @params

    respond_to do |format|
      format.html
      format.js { render 'user/open_educat/shared/student_projects/forms/ajax_response', locals: { result: result } }
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
    # TODO temporary load all projects
    # @course_projects = SocialCommunity::ScStudentProject.where(course_id: params[:course_id], permission: 'public').page params[:page]
    @course_projects = SocialCommunity::ScStudentProject.where(course_id: params[:course_id]).page params[:page]
  end

  def delete_student_project
    result = {}
    project = SocialCommunity::ScStudentProject.where(id: params[:project_id]).first

    if project.blank?
      result = { result: { type: "danger", message: "Dự án không tồn tại!"}, project_id: '' }
    elsif current_user.id != project.created_by
      result = { result: { type: "danger", message: "Bạn không có quyền xoá dự án này" }, project_id: '' }
    else
      result = SocialCommunity::ScStudentProjectsService.new.delete_student_project project
      #if project.delete
      #  result = { type: "success", message: "Xoá thành công!"}
      #  project_id = project.id
      #end
    end

    respond_to do |format|
      format.html
      format.js { render 'user/open_educat/shared/student_projects/js/delete_project', locals: result }
    end
  end

  private

  def handling_params
    @params = {}
    @params.merge! params[:social_community_sc_student_project].permit! if params[:social_community_sc_student_project].present?
    @params.merge! ({ state: params[:state]}) if params[:state].present?
    @params.merge! ({ project_id: params[:project_id]}) if params[:project_id].present?

    if @params['permission'] == '1'
      @params['permission'] = SocialCommunity::Constant::ScStudentProject::Permission::PUBLIC
    end

    @params['state'] = if @params['state'] == '1'
                              SocialCommunity::Constant::ScStudentProject::State::PUBLISH
                            else
                              SocialCommunity::Constant::ScStudentProject::State::DRAFT
                            end

    @params.select! { |k, v| v.present? }
    @params.symbolize_keys!
  end

  def validate_youtube_upload_params params
    (params[:batch_id].present? && params[:student_id].present? && params[:subject_id].present?) && ((params[:introduction_video].present? && params[:name].present?) || params[:presentation].present? || params[:project_show_video].present? )
  end

  def batch_student_info batch_id
    batch = Learning::Batch::OpBatch.where(id: batch_id).first
    course = batch.op_course
    subjects = course.op_subjects.pluck(:id, :level)
    student_ids = Learning::Batch::OpStudentCourse.where(batch_id: batch.id, state: 'on').pluck(:student_id)
    all_student = User::OpenEducat::OpStudent.where(id: student_ids).pluck(:id, :full_name)
    [subjects, all_student, batch]
  end
end


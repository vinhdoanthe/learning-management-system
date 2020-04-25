class Learning::Batch::SessionsController < ApplicationController
  def add_photo_attachment
    session = Learning::Batch::OpSession.where(id: params[:upload_session_id]).first
    result = SocialCommunity::PhotoService.new.add_photo_attachment session, params[:photos], current_user
    if result.present?
      render json: {type: 'danger', message: result}
    else
      render json: {type: 'success', message: 'Đăng ảnh thành công!' }
    end
  end

  def active_session
    session = Learning::Batch::OpSession.where(id: params[:session_id]).first
    lesson = session.op_lession
    subject = session.op_subject

    if lesson.present? && lesson.thumbnail.attached?
      thumbnail = lesson.thumbnail.service_url
    else
      thumbnail = ActionController::Base.helpers.asset_path('global/images/default-lesson-thumbnail.png')
    end

    respond_to do |format|
      format.html
      format.js { render 'user/open_educat/op_teachers/js/teacher_class_details/lession_information', locals: { session: session, lesson: lesson, thumbnail: thumbnail, subject: subject }}
    end
  end

  def session_attendance_info

  end

  def session_photo
    session = Learning::Batch::OpSession.where(id: params[:session_id]).first
    photos = session.photos

    respond_to do |format|
      format.html
      format.js { render 'user/open_educat/op_students/js/session_photo', locals: { photos: photos } }
    end
  end
    def session_reward
      session = Learning::Batch::OpSession.where(id: params[:session_id]).first
      batch = session.op_batch
      op_student_courses = batch.op_student_courses.where(state: 'on')
      students = []

      op_student_courses.each do |sc|
        students << sc.op_student
      end

      respond_to do |format|
        format.html
        format.js { render 'user/open_educat/op_teachers/js/teacher_class_details/reward_student', locals: { students: students } }
      end
    end
end

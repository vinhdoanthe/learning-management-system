class Adm::Learning::SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :find_session, only: [:session_photos, :session_attendances, :session_videos]

  def index
    @allow_companies =  if current_user.is_operation_admin?
                        current_user.res_companies
                      else
                        Common::ResCompany.all
                      end
    allow_company_ids = @allow_companies.pluck(:id)
    @allow_batches = Learning::Batch::OpBatch.where(company_id: allow_company_ids, state: [Learning::Constant::Batch::STATE_APPROVE, Learning::Constant::Batch::STATE_CONFIRM])
    @session_states = Learning::Batch::OpSession.pluck(:state).uniq
  end

  def filter_sessions
    service = Adm::Learning::SessionsService.new
    sessions = service.session_index params, current_user

    respond_to do |format|
      format.html
      format.js { render 'adm/learning/sessions/index_content', locals: { sessions: sessions, page: params[:page].to_i } }
    end
  end

  def session_photos
    photos = @session.photos

    respond_to do |format|
      format.html
      format.js { render 'adm/learning/sessions/js/session_photos', locals: { photos: photos } }
    end
  end

  def session_attendances
    attendances = @session.op_attendance_lines

    respond_to do |format|
      format.html
      format.js { render 'adm/learning/sessions/js/session_attendance', locals: { attendances: attendances } }
    end
  end

  def session_videos

  end

  private

  def find_session
    @session = Learning::Batch::OpSession.where(id: params[:session_id]).first
  end
end

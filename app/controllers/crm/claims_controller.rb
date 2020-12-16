class Crm::ClaimsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def new
    titles = {
      'reserve' => 'Đơn đề nghị bảo lưu',
      'refund' => 'Đơn đề nghị hoàn học phí',
      'change_company' => 'Đơn đề nghị chuyển lớp/ khoá/ cơ sở',
      'transfer' => 'Đơn đề nghị chuyển nhượng học phí'
    }
    @claim_forms = []

    titles.each do |k, v|
      @claim_forms << { type: k, link: "/crm/claims/new_claim?form=#{ k }", title: v}
    end

  end

  def index
    @claims = Crm::Claim.where(student_id: current_user.op_student.id).to_a
    @stage = {
      1 => 'Chờ xử lý',
      3 => 'Được chập nhận',
      5 => 'Đang xử lý',
      6 => 'Hoàn thành',
      7 => 'Bị từ chối'
    }
  end

  def show
    @claim = Crm::Claim.where(id: params[:id]).first
    @student = User::OpenEducat::OpStudent.where(id: @claim.student_id).first
    @parent = @student.op_parents.first
    @batch = Learning::Batch::OpBatch.where(id: @claim.from_batch_id).first
    @course = Learning::Course::OpCourse.where(id: @claim.from_course_id).first
    @company = Common::ResCompany.where(id: @claim.from_company_id).first
    @to_company = Common::ResCompany.where(id: @claim.to_company_id).first
    @to_course = Learning::Course::OpCourse.where(id: @claim.to_course_id).first
    @to_batch = Learning::Batch::OpBatch.where(id: @claim.to_batch_id).first

    @stage = {
      1 => 'Chờ xử lý',
      3 => 'Được chập nhận',
      5 => 'Đang xử lý',
      6 => 'Hoàn thành',
      7 => 'Bị từ chối'
    }

    respond_to do |f|
      f.html
      f.js { render 'crm/claims/detail' }
    end
  end

  def new_claim
    @student = current_user.op_student
    @parent = @student.op_parents.first
    @company = @student.res_company
    @category = {
      1   => "Đề nghị bảo lưu",
      2	  => "Đề nghị Chuyển lớp/ Chuyển cơ sở,",
      3	  => "Học bù",
      4	  => "Đề nghị Hoàn tiền",
      5	  => "Khiếu nại",
      39	=> "Tư vấn tuyển sinh",
      40	=> "Chuyển nhượng học phí"
    }

    @courses = @student.op_courses
    @batches = @student.op_batches
    @list_company = Common::ResCompany.all.to_a
    @company = @student.res_company
    @count_done_session = @student.op_sessions.where(state: 'done').count
    @count_incoming_session = @student.op_sessions.where.not(state: ['done', 'cancel']).count
    @form = params[:form]
    @companies = Common::ResCompany.all.to_a
    title = {
      'reserve' => 'Đơn đề nghị bảo lưu',
      'refund' => 'Đơn đề nghị hoàn học phí',
      'change_company' => 'Đơn đề nghị chuyển lớp/ khoá/ cơ sở',
      'transfer' => 'Đơn đề nghị chuyển nhượng học phí'
    }
    @title = title[params[:form]]
    @admission_mode = { 'batch' => 'Chuyển lớp học', 'course' => 'Chuyển khoá học', 'center' => 'Chuyển cơ sở' }
  end

  def create
    result = Crm::ClaimsService.new.create current_user, params

    respond_to do |format|
      format.html
      format.js { render 'crm/claims/response', locals: { noti: result } }
    end
  end

end

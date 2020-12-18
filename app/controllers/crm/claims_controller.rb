class Crm::ClaimsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!
  before_action :authenticate_student!

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
    @claims = Crm::Claim.where(student_id: current_user.op_student.id).order(create_date: :DESC).to_a
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

    @list_company = Common::ResCompany.all.to_a
    @company = @student.res_company
    @form = params[:form]
    @companies = Common::ResCompany.all.to_a
    @titles = {
      'reserve' => 'Đơn đề nghị bảo lưu',
      'refund' => 'Đơn đề nghị hoàn học phí',
      'change_company' => 'Đơn đề nghị chuyển lớp/ khoá/ cơ sở',
      'transfer' => 'Đơn đề nghị chuyển nhượng học phí'
    }
    @title = @titles[params[:form]]
    @admission_mode = { 'batch' => 'Chuyển lớp học', 'course' => 'Chuyển khoá học', 'center' => 'Chuyển cơ sở' }

    c_b = @student.op_sessions.pluck(:course_id, :batch_id).uniq
    @data = {}
    @course = {}
    @batch = {}
    c_b.each do |c, b|
      course = Learning::Course::OpCourse.where(id: c).first
      @course.merge!({ course.id => course.name })
      @data[course.id] = {} if @data[course.id].blank?

      batch = Learning::Batch::OpBatch.where(id: b).first
      @batch.merge!({ batch.id => batch.code })
      @data[course.id].merge!( { batch.id => {} })
    end

    @data.each do |k, v|
      v.each do |batch, _|
        done_ss = Learning::Batch::OpSession.where(batch_id: batch, course_id: k, state: 'done').count
        incoming_ss = Learning::Batch::OpSession.where(batch_id: batch, course_id: k).where.not( state: ['done', 'cancel']).count

        @data[k][batch] = { :done_ss => done_ss, :incoming_ss => incoming_ss }
      end
    end
  end

  def create
    result = Crm::ClaimsService.new.create current_user, params

    respond_to do |format|
      format.html
      format.js { render 'crm/claims/response', locals: { noti: result } }
    end
  end

end

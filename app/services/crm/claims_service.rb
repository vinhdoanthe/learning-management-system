class Crm::ClaimsService
  def create user, params
    category = {
      'reserve'         => 1,
      'change_company'  => 2,
      'refund'	        => 4,
      'transfer'	      => 40
    }
    name = {
      'reserve' => 'Đơn đề nghị bảo lưu',
      'refund' => 'Đơn đề nghị hoàn học phí',
      'change_company' => 'Đơn đề nghị chuyển lớp/ khoá/ cơ sở',
      'transfer' => 'Đơn đề nghị chuyển nhượng học phí'
    }
    student = user.op_student
    company = student.res_company
    parent = student&.op_parents.first

    claim = Crm::Claim.new
    code = generate_claim_code
    claim.code = code
    claim.active = true
    claim.name = name[params[:claim_form_type]]
    claim.description = params[:reason]
    claim.email_from = parent&.email
    claim.partner_phone = parent&.phone || parent&.mobile
    claim.create_date = Time.now
    claim.write_date = Time.now
    claim.date = Time.now
    claim.student_id = student.id
    claim.stage_id = 1
    claim.categ_id = category[params[:claim_form_type]]
    claim.company_id = company.id
    claim.admission_mode = params[:addmission_mode]
    claim.from_company_id = company.id
    claim.to_company_id = params[:company]
    claim.create_uid = 1
    claim.write_uid = 1

    if params[:claim_form_type] == 'transfer'
      claim.note = params[:transfer_student_name] + ' - ' + params[:count_transfer].to_s + ' buổi' if params[:transfer_student_name].present? && params[:count_transfer].present?
    elsif params[:claim_form_type] == 'reserve'
      claim.note = "Thời gian bảo lưu" + params[:start_reserve]
    end

    if params[:course].present? && params[:batch].present?
      batch = student.op_batches.where(id: params[:batch]).first
      if batch.present?
        sessions = batch.op_sessions.where(state: 'done').order(start_datetime: :DESC)
        count_done_session = sessions.count
        active_session = sessions.first

        claim.current_subject_id = active_session.subject_id
        claim.current_session_number = count_done_session
        claim.current_session_number_display = active_session.count
      end
    end

    claim.save

    #make_claim_attachment params[:claim_form_img], claim
    #claim.image.attach(io: File.open(Rails.root.join("app", "assets", "images", "claim#{ claim.id }.png")), filename: 'claim.png')

    #if claim.attachment_link = ActiveStorage::Blob.service.send(:path_for, claim.image.key)
    #  claim.save

    #  File.open("app/assets/images/claim#{ claim.id }.png", 'r') do |f|
    #    File.delete(f)
    #  end
    #end

    data = { student_name: student.full_name, parent_name: parent.full_name, odoo_url: claim.odoo_url, type: claim.name }

    begin
      SendGridMailer.new.send_email(EmailConstants::MailType::SEND_CLAIM_EMAIL_NOTI, data)

      result = { type: 'success', message: 'Gửi yêu cầu thành công! Yêu cầu của bạn sẽ được xử lý trong thời gian ngắn nhất có thể!' }
    rescue StandardError => e
      puts e
      result = { type: 'danger', message: 'Đã có lỗi xảy ra! Vui lòng thử lại sau' }
    end

    result
  end

  private

  def make_claim_attachment img_str, claim
    png = Base64.decode64(img_str['data:image/png;base64,'.length .. -1])

    File.open("app/assets/images/claim#{ claim.id }.png", 'wb') { |f| f.write(png) }
  end

  def generate_claim_code
    "LMS_CLM_#{ Time.now.to_i.to_s }"
  end
end

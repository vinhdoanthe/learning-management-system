class Adm::Learning::ActivityController < Adm::AdmController

  include ApplicationHelper

  #verify token authenticity
  skip_before_action :verify_authenticity_token

  def list_batch
    batch_name = params[:batch_name]
    company_id = 0
    list_batch = Learning::Batch::OpBatchService.find_batch_by_params(batch_name, company_id)
    render json: { results: list_batch}
  end

  # Quan ly Bai tap ve nha
  def homework
    # binding.pry
    @report_title_page = t('adm.learning_activity_management_homework')
    @param_form = Learning::Homework::UserAnswerService.form_parameter(params, request)
    # Danh sach
    @list_user_answers = Learning::Homework::UserAnswerService.get_user_answers_type_question_text(@param_form)
    # batch_params = {'company_id': 1,'start_date': @param_form[:from_date].to_s,'end_date': @param_form[:to_date].to_s,'active': true}
    #@list_batch = Learning::Batch::OpBatchService.find_batch_by_params(batch_params)
    #puts @list_batch
    # binding.pry
    return
  end
end

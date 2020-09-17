class Adm::Learning::BatchesController < Adm::AdmController
  def index
    if current_user.is_admin?
      @allow_batches = Learning::Batch::OpBatch.pluck(:id, :code)
    else
      company_ids = current_user.res_companies.pluck(:company_id)
      @allow_batches = Learning::Batch::OpBatch.where(company_id: company_ids).pluck(:id, :code)
    end

    @batch_places = Learning::Batch::OpBatch.pluck(:select_place).uniq
    @batch_states = Learning::Batch::OpBatch.pluck(:state).uniq
  end
end

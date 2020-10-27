class Adm::Contest::ContestExchangesController < Adm::AdmController
  skip_before_action :verify_authenticity_token, only: :create_new

  def index
    @contest_exchanges = Contest::ContestExchange.all
  end

  def create_new
    result = Adm::Contest::ContestExchangesService.new.create_new params

    render json: result
  end

  def update
    exchange = Contest::ContestExchange.where(id: params[:id]).first

    if exchange.present?
      status = if params[:status].to_boolean
                 'active'
               else
                 ''
               end
      if exchange.update(status: status)
      result = { type: 'success', message: 'Update thanh cong' }
      else
        result = { type: 'danger', message: 'da co loi xay ra! vui log thu laij sau' }
      end
    else
        result = { type: 'danger', message: 'quy doi khong ton tai! vui long thu laij sau' }
    end

    render json: result
  end
end

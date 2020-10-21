class Adm::Contest::ContestExchangesService
  def create_new params
    atts = ['top_from', 'top_end', 'point', 'title']
    exchange = Contest::ContestExchange.new

    atts.each do |att|
      exchange.send(att + '=', params[att])
    end

    binding.pry
    exchange.status = if params[:status].to_i == 1
                        'active'
                      else
                        ''
                      end

    if exchange.save
      result = { type: 'success', message: 'Tao thanh cong', exchange: exchange }
    else
      result = { type: 'danger', message: 'Da co loi xay ra! Vui long thu lai sau' }
    end

    result
  end
end

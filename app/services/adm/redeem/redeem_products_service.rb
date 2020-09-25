class Adm::Redeem::RedeemProductsService

  def filter_product_items params
    query = ''
    query_time = {}
    
    if params[:state].present?
      state = ''
      params[:state].split(',').each{|s| state += ("'" + s + "', ")}
      state.slice!(-2..-1)
      query += "state IN ( #{ state } ) AND "
    end

    query += "product_id IN ( #{ params[:products] } ) AND" if params[:products].present?
    query = query [0..-5]

    if params[:release_start].present? && params[:release_end]
      time_start = Time.new(params[:release_start][0..3].to_i, params[:release_start][4..5].to_i, params[:release_start][6..7].to_i)
      time_end = Time.new(params[:release_end][0..3].to_i, params[:release_end][4..5].to_i, params[:release_end][6..7].to_i)
      query_time.merge! ({ release_date: time_start..time_end })
    end

    if params[:input_start].present? && params[:input_end]
      time_start = Time.new(params[:input_start][0..3].to_i, params[:input_start][4..5].to_i, params[:input_start][6..7].to_i)
      time_end = Time.new(params[:input_end][0..3].to_i, params[:input_end][4..5].to_i, params[:input_end][6..7].to_i)
      query_time.merge! ({ input_date: time_start..time_end })
    end

    Redeem::RedeemProductItem.includes(:redeem_product, :redeem_product_color, :redeem_product_size, :redeem_transaction).where(query).where(query_time).order(:created_at => :ASC).page(params[:page]).per(25)
  end

end

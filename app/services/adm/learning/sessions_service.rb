class Adm::Learning::SessionsService

  def session_index params, user
    offset = 0
    offset = ( params[:page].to_i ) * 25 if params[:page].present?
    query = ''
    allow_companies = get_allow_user_companies user
    query += "op_batch.id IN (#{ params[:batch_id].join(',') }) AND " if params[:batch_id].present?

    if params[:company_id].present?
      query += "op_batch.company_id IN (#{ params[:company_id].join(',') }) AND "
    elsif allow_companies.present?
      query += "op_batch.company_id IN (#{ allow_companies.join(',') }) AND "
    end

    if params[:state].present?
      state = convert_string_in_query params[:state]
      query += "op_session.state IN ( #{ state } ) AND " if params[:state].present?
    end

    if params[:photo_state] == '1'
      query += "photos.id IS NOT NULL AND " 
    elsif params[:photo_state] == '0'
      query += "photos.id IS NULL AND "
    end

    query = query[0..-5]
    sessions = Learning::Batch::OpSession.includes(:op_batch, :res_company , :photos, :op_lession).where(query).where(start_datetime: (params[:start_time].to_datetime..params[:end_time].to_datetime)).distinct.order(start_datetime: :DESC).limit(25).offset(offset).pluck(:id, :state, :start_datetime, :end_datetime, 'op_batch.code', 'op_batch.id', 'op_batch.company_id', 'res_company.name', 'op_lession.name', 'op_lession.id', 'op_session.count')

    sessions.map!{ |info| { id: info[0], state: info[1], start_datetime: info[2], end_datetime: info[3], batch_id: info[5], batch_code: info[4], company_id: info[6], company_name: info[7], lesson_name: info[8], lesson_id: info[9], session_count: info[10] } }
    
  end

  def get_allow_user_companies user
    if user.is_operation_admin?
      user.user_companies.pluck(:company_id)
    else
      []
    end
  end

  def convert_string_in_query arr_str
    str = arr_str.to_s.gsub "\"", "'"
    str = str.delete ']'
    str = str.delete '['

    str
  end
end

class Report::ReportService
  
  # Lay param form
  def self.form_parameter(param_form, request)
    
    # Khoi tao cac gia tri ban dau
    current_date_dmy  = Time.now.strftime('%d-%m-%Y').to_s
    string_date_format_dmy  = '%d-%m-%Y'
    string_date_format_ymd  = '%Y%m%d'
    sql_date_format_ymd     = 'YYYYMMDD'
    sql_date_format_dmy     = 'DD-MM-YYYY'
    from_date = to_date = current_date_dmy
    company_id = 0
    report_type = 'range'
    
    if request.method == 'POST'
      
      company_id  = param_form[:frm_report][:company_id].to_i > 0 ? param_form[:frm_report][:company_id].to_i : 0
      report_type = param_form[:frm_report][:report_type].to_s != '' ? param_form[:frm_report][:report_type].to_s : 'range'
      
      from_date = Date.parse(param_form[:frm_report][:from_date].to_s).is_a?(Date) ? param_form[:frm_report][:from_date].to_s : current_date_dmy
      to_date   = Date.parse(param_form[:frm_report][:to_date].to_s).is_a?(Date) ? param_form[:frm_report][:to_date].to_s : current_date_dmy
      to_date = Date.parse(from_date).strftime(string_date_format_ymd).to_i > Date.parse(to_date).strftime(string_date_format_ymd).to_i ? from_date : to_date
      
      #report_type = company_id <= 0 ? 'range' : report_type
          
    end
    
    # label of chart js
    labels = []
    if report_type == 'range'
      labels = (Date.parse(from_date) .. Date.parse(to_date)).to_a.map { |e|e.strftime(string_date_format_dmy).to_s }
    elsif report_type == 'year'
      string_date_format_ymd  = '%Y'
      string_date_format_dmy  = '%Y'
      sql_date_format_dmy     = 'YYYY'
      sql_date_format_ymd     = 'YYYY'
      labels = (Date.parse(from_date).strftime(string_date_format_ymd).to_s .. Date.parse(to_date).strftime(string_date_format_ymd).to_s).to_a
    elsif report_type == 'month'
      string_date_format_ymd  = '%Y%m'
      string_date_format_dmy  = '%m-%Y'
      sql_date_format_dmy     = 'MM-YYYY'
      sql_date_format_ymd     = 'YYYYMM'
      date_range = (Date.parse(from_date) .. Date.parse(to_date)).map {|d| Date.new(d.year, d.month, 1) }.uniq
      labels = date_range.map {|d| d.strftime(string_date_format_dmy).to_s}
    elsif report_type == 'week'
      sql_date_format_dmy     = 'IW-YYYY'
      sql_date_format_ymd     = 'YYYYIW'
      
      if (Date.parse(from_date).strftime("%Y").to_i != Date.parse(to_date).strftime("%Y").to_i)
        @labels = (Date.parse(from_date)..Date.parse(to_date)).step(7).map {|d| (d.strftime("%V").to_s + "(" + d.strftime("%Y").to_s + ")" + "(" + d.beginning_of_week.strftime("%d-%m-%Y").to_s + " : " +  d.end_of_week.strftime("%d-%m-%Y").to_s   +   ")")}
      else
        @labels = (Date.parse(from_date)..Date.parse(to_date)).step(7).map {|d| (d.strftime("%V").to_s + "(" + d.beginning_of_week.strftime("%d-%m-%Y").to_s + " : " +  d.end_of_week.strftime("%d-%m-%Y").to_s   +   ")")}
      end
    end
    
    set_params = {
      'string_date_format_dmy'  => string_date_format_dmy,
        
      'string_date_format_ymd'  => string_date_format_ymd,
        
      'sql_date_format_dmy'     => sql_date_format_dmy,
        
      'sql_date_format_ymd'     => sql_date_format_ymd,
       
      'labels'                  => labels,
       
      'frm_report'              =>  {
          'report_type': report_type ,
          'from_date': from_date,
          'to_date': to_date,
          'company_id': company_id
      }
    }
    
    return set_params

  end
  
  # Ham thong ke giao vien check-in; not check in theo company_id va quang thoi gian
  def self.statistic_teaching_checkin_range(company_id, sql_date_format_ymd, sql_date_format_dmy,sql_from_date, sql_to_date)
    if company_id <= 0
    return Common::ResCompany
          .joins("left join op_batch as bat ON res_company.id = bat.company_id")
          .joins("left join op_session as a ON (a.batch_id = bat.id AND a.start_datetime IS NOT NULL AND (TO_CHAR(a.start_datetime, '#{sql_date_format_ymd}') >=  '#{sql_from_date}' AND TO_CHAR(a.end_datetime, '#{sql_date_format_ymd}') <=  '#{sql_to_date}'))")
          .where.not(:id => [3,19,36,10,11,17,12,13,18,16])
          .select("res_company.id as id, res_company.name as name, res_company.code as code,
            SUM(case WHEN a.check_in_state = 'good' then 1 ELSE 0 END) as total_check_in,
            SUM(case WHEN a.check_in_state = 'none' then 1 ELSE 0 END) as total_not_check_in")
          .group('res_company.id')
          .order(code: :DESC)
    else
      return Common::ResCompany
            .joins("left join op_batch as bat ON res_company.id = bat.company_id")
            .joins("left join op_session as a ON (a.batch_id = bat.id AND a.start_datetime IS NOT NULL AND (TO_CHAR(a.start_datetime, '#{sql_date_format_ymd}') >=  '#{sql_from_date}' AND TO_CHAR(a.end_datetime, '#{sql_date_format_ymd}') <=  '#{sql_to_date}'))")
            .where(:id => company_id)
            .select("
              TO_CHAR(a.start_datetime, '#{sql_date_format_ymd}') as date_report_ymd,
              TO_CHAR(a.start_datetime, '#{sql_date_format_dmy}') as date_report,
              SUM(case WHEN a.check_in_state = 'good' then 1 ELSE 0 END) as total_check_in,
              SUM(case WHEN a.check_in_state = 'none' then 1 ELSE 0 END) as total_not_check_in")
            .group('date_report_ymd,date_report')
            .order("date_report_ymd")
    end
  end

  # Ham thong ke giao vien check-in; not check in theo company_id va quang thoi gian
  def self.statistic_teaching_checkin_year_or_month(company_id, sql_date_format_ymd,sql_date_format_dmy, sql_from_date, sql_to_date)
    
    if company_id <= 0      
      data_chart = Common::ResCompany
          .joins("left join op_batch as bat ON res_company.id = bat.company_id")
          .joins("left join op_session as a ON (a.batch_id = bat.id AND a.start_datetime IS NOT NULL AND (TO_CHAR(a.start_datetime, '#{sql_date_format_ymd}') >=  '#{sql_from_date}' AND TO_CHAR(a.end_datetime, '#{sql_date_format_ymd}') <=  '#{sql_to_date}'))")
          .where.not(:id => [3,19,36,10,11,17,12,13,18,16])
          .where("a.start_datetime IS NOT NULL")
          .select("TO_CHAR(a.start_datetime, '#{sql_date_format_ymd}') as date_report_ymd,
            SUM(case WHEN a.check_in_state = 'good' then 1 ELSE 0 END) as total_check_in,
            SUM(case WHEN a.check_in_state = 'none' then 1 ELSE 0 END) as total_not_check_in")
          .group('date_report_ymd')
          .order('date_report_ymd')

        data_company = Common::ResCompany
          .joins("left join op_batch as bat ON res_company.id = bat.company_id")
          .joins("left join op_session as a ON (a.batch_id = bat.id AND a.start_datetime IS NOT NULL AND (TO_CHAR(a.start_datetime, '#{sql_date_format_ymd}') >=  '#{sql_from_date}' AND TO_CHAR(a.end_datetime, '#{sql_date_format_ymd}') <=  '#{sql_to_date}'))")
          .where.not(:id => [3,19,36,10,11,17,12,13,18,16])          
          .where("a.start_datetime IS NOT NULL")
          .select("res_company.id as id, res_company.name as name, res_company.code as code,
            TO_CHAR(a.start_datetime, '#{sql_date_format_ymd}') as date_report_ymd,
            SUM(case WHEN a.check_in_state = 'good' then 1 ELSE 0 END) as total_check_in,
            SUM(case WHEN a.check_in_state = 'none' then 1 ELSE 0 END) as total_not_check_in")
          .group('res_company.id,date_report_ymd')
          .order("date_report_ymd ASC, res_company.code")

        return {'data_chart' => data_chart, 'data_company' => data_company}

    else
      return Common::ResCompany
            .joins("left join op_batch as bat ON res_company.id = bat.company_id")
            .joins("left join op_session as a ON (a.batch_id = bat.id AND (TO_CHAR(a.start_datetime, '#{sql_date_format_ymd}') >=  '#{sql_from_date}' AND TO_CHAR(a.end_datetime, '#{sql_date_format_ymd}') <=  '#{sql_to_date}'))")
            .where(:id => company_id)
            .where("a.start_datetime IS NOT NULL")
            .select("res_company.id as id, res_company.name as name, res_company.code as code,
              TO_CHAR(a.start_datetime, '#{sql_date_format_ymd}') as date_report_ymd,
              TO_CHAR(a.start_datetime, '#{sql_date_format_dmy}') as date_report,
              SUM(case WHEN a.check_in_state = 'good' then 1 ELSE 0 END) as total_check_in,
              SUM(case WHEN a.check_in_state = 'none' then 1 ELSE 0 END) as total_not_check_in")
            .group('res_company.id,date_report_ymd,date_report')
            .order("date_report_ymd")
    end
  end

  # Ham thong ke giao vien check-in; not check in cua mot company_id va quang thoi gian
  def self.statistic_teacher_checkin(company_id, sql_date_format_ymd,sql_date_format_dmy, sql_from_date, sql_to_date)

    return Learning::Batch::OpSession
    .joins("inner join op_faculty as op_f ON op_f.id = op_session.faculty_id")
    .where(:company_id => company_id)
    .where("op_session.start_datetime IS NOT NULL")
    .where("TO_CHAR(op_session.start_datetime, '#{sql_date_format_ymd}') >=  '#{sql_from_date}' AND TO_CHAR(op_session.end_datetime, '#{sql_date_format_ymd}') <=  '#{sql_to_date}'")
    .select("op_session.faculty_id, op_f.middle_name as middle_name, op_f.last_name as last_name,
      SUM(case WHEN op_session.check_in_state = 'good' then 1 ELSE 0 END) as total_check_in,
      SUM(case WHEN op_session.check_in_state = 'none' then 1 ELSE 0 END) as total_not_check_in")
    .group("op_session.faculty_id,op_f.id")
    .order("op_session.faculty_id")

  end
  
end

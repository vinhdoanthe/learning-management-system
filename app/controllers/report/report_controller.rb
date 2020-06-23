module Report
  class ReportController < ApplicationController
    skip_before_action :verify_authenticity_token

    # Bao cao chuyen can
    def diligent
      @report_title_page = t('report.report_diligent_title')

      @list_company = Common::ResCompany.where.not(:id => [3,19,36,10,11,17,12,13,18,16]).select(:id, :name)

      current_date_format = Time.now.strftime("%d-%m-%Y").to_s

      @params = []
      @list_date = []
      company_id = 0
      report_type = 'range'
      string_date_format_dmy = '%d-%m-%Y'
      string_date_format_ymd = '%Y%m%d'
      sql_date_format_ymd     = 'YYYYMMDD'

      from_date = to_date = Time.now.strftime(string_date_format_ymd).to_s
      @frm_report = {'report_type': report_type,'from_date': from_date,'to_date': to_date, 'company_id': company_id}

      if request.method == 'POST'
        @params   = params

        company_id  = params[:frm_report][:company_id].to_i > 0 ? params[:frm_report][:company_id].to_i : 0
        report_type = params[:frm_report][:report_type].to_s != '' ? params[:frm_report][:report_type].to_s : 'range'

        if report_type == 'year'
          string_date_format_dmy = '%Y'
          string_date_format_ymd = '%Y'
          sql_date_format_ymd    = 'YYYY'
        elsif report_type == 'month'

        end

        from_date = Date.parse(params[:frm_report][:from_date].to_s).is_a?(Date) ? params[:frm_report][:from_date].to_s : current_date_format                    
        to_date   = Date.parse(params[:frm_report][:to_date].to_s).is_a?(Date) ? params[:frm_report][:to_date].to_s : current_date_format

        to_date = Date.parse(from_date).strftime(string_date_format_ymd).to_s > Date.parse(to_date).strftime(string_date_format_ymd).to_s ? from_date : to_date


        @frm_report = {
          'report_type': report_type,
          'from_date': from_date,
          'to_date': to_date,
          'company_id': company_id
        }

        if (params[:frm_report][:company_id].to_i > 0)
          if (report_type == 'range')
            date_range = Date.parse(from_date) .. Date.parse(to_date)          
            @list_date = date_range.to_a.map { |e|e.strftime(string_date_format_dmy).to_s }
            from_date = Date.parse(from_date).strftime(string_date_format_ymd).to_s
            to_date   = Date.parse(to_date).strftime(string_date_format_ymd).to_s
          elsif (report_type == 'year')
            from_date = Date.parse(from_date).strftime(string_date_format_ymd).to_s
            to_date   = Date.parse(to_date).strftime(string_date_format_ymd).to_s
            @list_date = (from_date .. to_date).to_a
          end
        else
          date_range = Date.parse(from_date) .. Date.parse(to_date)          
          @list_date = date_range.to_a.map { |e|e.strftime(string_date_format_dmy).to_s }

          from_date = Date.parse(from_date).strftime(string_date_format_ymd).to_s
          to_date   = Date.parse(to_date).strftime(string_date_format_ymd).to_s
        end

      end


      if company_id <= 0    
        # Danh sach di hoc
        @list_present = Common::ResCompany
          .joins("left join op_session_student as ss ON (res_company.id = ss.company_id AND ss.present IS true AND (TO_CHAR(ss.start_datetime, '#{sql_date_format_ymd}') >=  '#{from_date}' AND TO_CHAR(ss.start_datetime, '#{sql_date_format_ymd}') <=  '#{to_date}'))")
          .where.not(:id => [3,19,36,10,11,17,12,13,18,16])
          .select('res_company.id as id, res_company.name as name, count(ss.id) as cnt_present')
          .group('res_company.id, ss.company_id')
          .order(code: :DESC)

        # Danh sach nghi hoc
        @list_no_present = Common::ResCompany
          .joins("left join op_session_student as ss ON (res_company.id = ss.company_id AND ss.present IS false AND (TO_CHAR(ss.start_datetime, '#{sql_date_format_ymd}') >=  '#{from_date}' AND TO_CHAR(ss.start_datetime, '#{sql_date_format_ymd}') <=  '#{to_date}'))")
          .where.not(:id => [3,19,36,10,11,17,12,13,18,16])
          .select('res_company.id as id, res_company.name as name, count(ss.id) as cnt_present')
          .group('res_company.id, ss.company_id')
          .order("date_report")
      else
        # Danh sach di hoc
        @list_present = Learning::Batch::OpSessionStudent.where(:id => company_id).where("op_session_student.present IS true AND (TO_CHAR(op_session_student.start_datetime, '#{sql_date_format_ymd}') >=  '#{from_date}' AND TO_CHAR(op_session_student.start_datetime, '#{sql_date_format_ymd}') <=  '#{to_date}')")
          .select("op_session_student.company_id as id, '' as name, count(op_session_student.id) as cnt_present, TO_CHAR(op_session_student.start_datetime, '#{sql_date_format_ymd}') as date_report")
          .group('op_session_student.company_id,date_report')
          .order("date_report")

        # Danh sach nghi hoc
        @list_no_present = Learning::Batch::OpSessionStudent.where(:id => company_id).where("op_session_student.present IS false AND (TO_CHAR(op_session_student.start_datetime, '#{sql_date_format_ymd}') >=  '#{from_date}' AND TO_CHAR(op_session_student.start_datetime, '#{sql_date_format_ymd}') <=  '#{to_date}')")
          .select("op_session_student.company_id as id, '' as name, count(op_session_student.id) as cnt_present, TO_CHAR(op_session_student.start_datetime, '#{sql_date_format_ymd}') as date_report")
          .group('op_session_student.company_id,date_report')
          .order(start_datetime: :DESC)
      end

      @data_company = []
      data = []
      for present in @list_present

        for no_present in @list_no_present
          if (present.id == no_present.id)

            scale_present = (present.cnt_present.to_i == 0 && no_present.cnt_present.to_i==0) ? 0 : 100*present.cnt_present.to_i/(present.cnt_present.to_i + no_present.cnt_present.to_i)

            data << {
              id: present.id || '',
              name: present.name || '',
              student_present: present.cnt_present.to_i || 0,
              student_no_present: no_present.cnt_present.to_i || 0,
              scale_present: scale_present,
              scale_no_present: (present.cnt_present.to_i == 0 && no_present.cnt_present.to_i==0) ? 0 : (100 - scale_present).to_i,
              presentBackgroundColor: (present.cnt_present.to_i == 0 && no_present.cnt_present.to_i==0) ? 'transparent' : 'rgb(54, 162, 235)',                       
              noPresentBackgroundColor: (present.cnt_present.to_i == 0 && no_present.cnt_present.to_i==0) ? 'transparent' : 'rgb(201, 203, 207)'
            }
          end          
        end         
      end

      @data_company = data

      respond_to do |format|
        format.html { render 'report/diligent'}
      end
    end

    # Bao cao hoc tap
    def study
      @report_title_page = t('Report.report_study_title')


      respond_to do |format|
        format.html { render 'report/study'}
      end
    end

    # Bao cao tong hop
    def general
      @report_title_page = t('Report.report_general_title')        

      respond_to do |format|
        format.html { render 'report/general'}
      end
    end

  end
end

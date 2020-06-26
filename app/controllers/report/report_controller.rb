module Report
  class ReportController < ApplicationController
    skip_before_action :verify_authenticity_token

    # Bao cao chuyen can
    def diligent
      @sub_module = 'diligent'
      @report_title_page = t('report.report_diligent_title')
      @params     = []
      @list_date  = []
      @labels     = []
      company_id  = 0
      report_type = 'range'
      string_date_format_dmy  = '%d-%m-%Y'
      string_date_format_ymd  = '%Y%m%d'
      sql_date_format_ymd     = 'YYYYMMDD'
      sql_date_format_dmy     = 'DD-MM-YYYY'

      current_date_ymd  = Time.now.strftime(string_date_format_ymd).to_s
      current_date_dmy  = Time.now.strftime(string_date_format_dmy).to_s

      from_date = to_date = current_date_dmy

      # Khoi tao form ban dau
      @frm_report = {'report_type': report_type,'from_date': current_date_dmy,'to_date': current_date_dmy, 'company_id': company_id}

      if request.method == 'POST'
        #binding.pry
        @params   = params
        company_id  = params[:frm_report][:company_id].to_i > 0 ? params[:frm_report][:company_id].to_i : 0
        report_type = params[:frm_report][:report_type].to_s != '' ? params[:frm_report][:report_type].to_s : 'range'

        if company_id <= 0
          report_type = 'range'
        end

        from_date = Date.parse(params[:frm_report][:from_date].to_s).is_a?(Date) ? params[:frm_report][:from_date].to_s : current_date_dmy
        to_date   = params[:frm_report][:to_date] != '' && Date.parse(params[:frm_report][:to_date]).is_a?(Date) ? params[:frm_report][:to_date].to_s : current_date_dmy
        to_date = Date.parse(from_date).strftime(string_date_format_ymd).to_i > Date.parse(to_date).strftime(string_date_format_ymd).to_i ? from_date : to_date

        @frm_report = {'report_type': report_type,'from_date': from_date,'to_date': to_date,'company_id': company_id}

        if company_id <= 0
          date_range = Date.parse(from_date) .. Date.parse(to_date)
          @list_date = date_range.to_a.map { |e|e.strftime(string_date_format_dmy).to_s }
        else

          if report_type == 'range'
            date_range = Date.parse(from_date) .. Date.parse(to_date)
            @list_date = date_range.to_a.map { |e|e.strftime(string_date_format_dmy).to_s }
          else
            if report_type == 'year'
              string_date_format_ymd  = '%Y'
              string_date_format_dmy  = '%Y'
              sql_date_format_dmy     = 'YYYY'
              sql_date_format_ymd     = 'YYYY'
              @list_date = (Date.parse(from_date).strftime(string_date_format_ymd).to_s .. Date.parse(to_date).strftime(string_date_format_ymd).to_s).to_a
            elsif report_type == 'month'
              string_date_format_ymd  = '%Y%m'
              string_date_format_dmy  = '%m-%Y'
              sql_date_format_dmy     = 'MM-YYYY'
              sql_date_format_ymd     = 'YYYYMM'
              date_range = (Date.parse(from_date) .. Date.parse(to_date)).map {|d| Date.new(d.year, d.month, 1) }.uniq

              @list_date = date_range.map {|d| d.strftime(string_date_format_dmy).to_s}
            elsif report_type == 'week'

              sql_date_format_dmy     = 'IW-YYYY'
              sql_date_format_ymd     = 'YYYYIW'

              # Lay so thu tu cua tuan
              @list_date = (Date.parse(from_date)..Date.parse(to_date)).step(7).map {|d|d.strftime("%V-%Y").to_s}

              puts "Danh sach tuan:"
              puts @list_date

              puts "Start date: "
              monday = Date.parse(from_date).beginning_of_week
              puts monday

              sunday = Date.parse(from_date).end_of_week
              puts "End date: "
              puts sunday

              if (Date.parse(from_date).strftime("%Y").to_i != Date.parse(to_date).strftime("%Y").to_i)
                @labels = (Date.parse(from_date)..Date.parse(to_date)).step(7).map {|d| (d.strftime("%V").to_s + "(" + d.strftime("%Y").to_s + ")" + "(" + d.beginning_of_week.strftime("%d-%m-%Y").to_s + " : " +  d.end_of_week.strftime("%d-%m-%Y").to_s   +   ")")}
              else
                @labels = (Date.parse(from_date)..Date.parse(to_date)).step(7).map {|d| (d.strftime("%V").to_s + "(" + d.beginning_of_week.strftime("%d-%m-%Y").to_s + " : " +  d.end_of_week.strftime("%d-%m-%Y").to_s   +   ")")}
              end
            end
          end
        end
      end

      # convert format for query param sql
      sql_from_date = Date.parse(from_date).strftime(string_date_format_ymd).to_s
      sql_to_date   = Date.parse(to_date).strftime(string_date_format_ymd).to_s

      # get list company
      @list_company =  Report::CompanyService.get_list_company
      @data_company = []
      data          = []
      data_temps    = []
      
      if company_id <= 0
        # Danh sach di hoc
        @list_present = Common::ResCompany
          .joins("left join op_session_student as ss ON (res_company.id = ss.company_id AND ss.present IS true AND (TO_CHAR(ss.start_datetime, '#{sql_date_format_ymd}') >=  '#{sql_from_date}' AND TO_CHAR(ss.start_datetime, '#{sql_date_format_ymd}') <=  '#{sql_to_date}'))")
          .where.not(:id => [3,19,36,10,11,17,12,13,18,16])
          .select('res_company.id as id, res_company.name as name, count(ss.id) as cnt_present')
          .group('res_company.id, ss.company_id')
          .order(code: :DESC)

        # Danh sach nghi hoc
        @list_no_present = Common::ResCompany
          .joins("left join op_session_student as ss ON (res_company.id = ss.company_id AND ss.present IS false AND (TO_CHAR(ss.start_datetime, '#{sql_date_format_ymd}') >=  '#{sql_from_date}' AND TO_CHAR(ss.start_datetime, '#{sql_date_format_ymd}') <=  '#{sql_to_date}'))")
          .where.not(:id => [3,19,36,10,11,17,12,13,18,16])
          .select('res_company.id as id, res_company.name as name, count(ss.id) as cnt_present')
          .group('res_company.id, ss.company_id')
          .order(code: :DESC)

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
      else

        data_coms     = []

        for value_date in @list_date
          data_coms <<  {
            id: value_date,
            name: '',
            student_present: nil,
            student_no_present: nil,
            scale_present: nil,
            scale_no_present: nil,
            presentBackgroundColor: 'transparent',
            noPresentBackgroundColor: 'transparent'
          }
        end

        if report_type != 'week'
          # Danh sach di hoc
          @list_present = Learning::Batch::OpSessionStudent
            .where(:company_id => company_id)
            .where("op_session_student.present IS true AND (TO_CHAR(op_session_student.start_datetime, '#{sql_date_format_ymd}') >=  '#{sql_from_date}' AND TO_CHAR(op_session_student.start_datetime, '#{sql_date_format_ymd}') <=  '#{sql_to_date}')")
            .select("op_session_student.company_id as id, '' as name, count(op_session_student.id) as cnt_present, TO_CHAR(op_session_student.start_datetime, '#{sql_date_format_ymd}') as date_report_ymd ,TO_CHAR(op_session_student.start_datetime, '#{sql_date_format_dmy}') as date_report")
            .group('op_session_student.company_id,date_report_ymd,date_report')
            .order("date_report_ymd")

          # Danh sach nghi hoc
          @list_no_present = Learning::Batch::OpSessionStudent
            .where(:company_id => company_id)
            .where("op_session_student.present IS false AND (TO_CHAR(op_session_student.start_datetime, '#{sql_date_format_ymd}') >=  '#{sql_from_date}' AND TO_CHAR(op_session_student.start_datetime, '#{sql_date_format_ymd}') <=  '#{sql_to_date}')")
            .select("op_session_student.company_id as id, '' as name, count(op_session_student.id) as cnt_present, TO_CHAR(op_session_student.start_datetime, '#{sql_date_format_ymd}') as date_report_ymd ,TO_CHAR(op_session_student.start_datetime, '#{sql_date_format_dmy}') as date_report")
            .group('op_session_student.company_id,date_report_ymd, date_report')
            .order("date_report_ymd")
        else
          # Danh sach di hoc theo tuan
          @list_present = Learning::Batch::OpSessionStudent
            .where(:company_id => company_id)
            .where("op_session_student.present IS true")
            .where("TO_CHAR(op_session_student.start_datetime, '#{sql_date_format_ymd}') >=  TO_CHAR(TIMESTAMP '#{sql_from_date}', '#{sql_date_format_ymd}') ")
            .where("TO_CHAR(op_session_student.start_datetime, '#{sql_date_format_ymd}') <=  TO_CHAR(TIMESTAMP '#{sql_to_date}', '#{sql_date_format_ymd}') ")
            .select("op_session_student.company_id as id, '' as name, count(op_session_student.id) as cnt_present, TO_CHAR(op_session_student.start_datetime, '#{sql_date_format_ymd}') as date_report_ymd ,TO_CHAR(op_session_student.start_datetime, '#{sql_date_format_dmy}') as date_report")
            .group('op_session_student.company_id,date_report_ymd, date_report')
            .order("date_report_ymd")

          # Danh sach nghi hoc theo tuan
          @list_no_present = Learning::Batch::OpSessionStudent
            .where(:company_id => company_id)
            .where("op_session_student.present IS false")
            .where("TO_CHAR(op_session_student.start_datetime, '#{sql_date_format_ymd}') >=  TO_CHAR(TIMESTAMP '#{sql_from_date}', '#{sql_date_format_ymd}') ")
            .where("TO_CHAR(op_session_student.start_datetime, '#{sql_date_format_ymd}') <=  TO_CHAR(TIMESTAMP '#{sql_to_date}', '#{sql_date_format_ymd}') ")
            .select("op_session_student.company_id as id, '' as name, count(op_session_student.id) as cnt_present, TO_CHAR(op_session_student.start_datetime, '#{sql_date_format_ymd}') as date_report_ymd ,TO_CHAR(op_session_student.start_datetime, '#{sql_date_format_dmy}') as date_report")
            .group('op_session_student.company_id,date_report_ymd, date_report')
            .order('date_report_ymd')
        end

        puts "Di hoc:"
        puts @list_present

        puts "Nghi hoc:"
        puts @list_no_present

        # MAP data di hoc
        i = 0
        for data_com in data_coms
          for present in @list_present
            if (data_com[:id] == present.date_report)
              data_coms[i] = {
                id: present.date_report || '',
                name: present.name || '',
                student_present: present.cnt_present.to_i || 0,
                student_no_present: 0,
                scale_present: 0,
                scale_no_present: 0,
                presentBackgroundColor: 'transparent',                       
                noPresentBackgroundColor: 'transparent'
              }
            end
          end
          i = i+1
        end

        # MAP data nghi hoc
        i = 0
        for data_com in data_coms
          for no_present in @list_no_present
            if (data_com[:id] == no_present.date_report)
              scale_present = (data_com[:student_present].to_i == 0 && no_present.cnt_present.to_i==0) ? 0 : 100*data_com[:student_present].to_i/(data_com[:student_present].to_i + no_present.cnt_present.to_i)
              data_coms[i] = {
                id: data_com[:id] || '',
                name: data_com[:name] || '',
                student_present: data_com[:student_present],
                student_no_present: no_present.cnt_present.to_i || 0,
                scale_present: scale_present,
                scale_no_present: (data_com[:student_present].to_i == 0 && no_present.cnt_present.to_i==0) ? 0 : (100 - scale_present).to_i,
                presentBackgroundColor: (data_com[:student_present].to_i == 0 && no_present.cnt_present.to_i==0) ? 'transparent' : 'rgb(54, 162, 235)',                       
                noPresentBackgroundColor: (data_com[:student_present].to_i == 0 && no_present.cnt_present.to_i==0) ? 'transparent' : 'rgb(201, 203, 207)'
              }
            end
          end
          i = i+1
        end

        #
        #for present in @list_present
        #  for no_present in @list_no_present
        #    if (present.date_report == no_present.date_report)
        #      scale_present = (present.cnt_present.to_i == 0 && no_present.cnt_present.to_i==0) ? 0 : 100*present.cnt_present.to_i/(present.cnt_present.to_i + no_present.cnt_present.to_i)
        #      data_temps << {
        #        id: present.date_report || '',
        #        name: present.name || '',
        #        student_present: present.cnt_present.to_i || 0,
        #        student_no_present: no_present.cnt_present.to_i || 0,
        #        scale_present: scale_present,
        #        scale_no_present: (present.cnt_present.to_i == 0 && no_present.cnt_present.to_i==0) ? 0 : (100 - scale_present).to_i,
        #        presentBackgroundColor: (present.cnt_present.to_i == 0 && no_present.cnt_present.to_i==0) ? 'transparent' : 'rgb(54, 162, 235)',                       
        #        noPresentBackgroundColor: (present.cnt_present.to_i == 0 && no_present.cnt_present.to_i==0) ? 'transparent' : 'rgb(201, 203, 207)'
        #      }
        #    end
        #  end
        #end
        #

        # if report_type != 'week'
        #   for value_date in @list_date
        #     data_coms <<  {
        #       id: value_date,
        #       name: '',
        #       student_present: nil,
        #       student_no_present: nil,
        #       scale_present: nil,
        #       scale_no_present: nil,
        #       presentBackgroundColor: 'transparent',
        #       noPresentBackgroundColor: 'transparent'
        #     }
        #   end
        # else
        #   for value_date in @list_date
        #     data_coms <<  {
        #       id: value_date,
        #       name: '',
        #       student_present: nil,
        #       student_no_present: nil,
        #       scale_present: nil,
        #       scale_no_present: nil,
        #       presentBackgroundColor: 'transparent',
        #       noPresentBackgroundColor: 'transparent'
        #     }
        #   end
        # end

        #puts data_coms
        #i = 0
        #for data_com in data_coms
        #  for data_temp in data_temps
        #    if data_temp[:id].to_s == data_com[:id].to_s
        #      scale_present = (data_temp[:student_present] == 0 && data_temp[:student_no_present] == 0) ? 0 : 100*data_temp[:student_present]/(data_temp[:student_present] + data_temp[:student_no_present])
        #      data_coms[i] = {
        #        id: data_temp[:id],
        #        name: data_temp[:name] || '',
        #        student_present: data_temp[:student_present],
        #        student_no_present: data_temp[:student_no_present],
        #        scale_present: scale_present,
        #        scale_no_present: (data_temp[:student_present] == 0 && data_temp[:student_no_present] == 0) ? 0 : (100 - scale_present).to_i,
        #        presentBackgroundColor: (data_temp[:student_present] == 0 && data_temp[:student_no_present] == 0) ? 'transparent' : 'rgb(54, 162, 235)',
        #        noPresentBackgroundColor: (data_temp[:student_present] == 0 && data_temp[:student_no_present] == 0) ? 'transparent' : 'rgb(201, 203, 207)'
        #      }
        #    end
        #  end
        #  i = i+1
        #end

        @data_company = data_coms
      end

      respond_to do |format|
        format.html { render 'report/diligent'}
      end
    end

    # Bao cao giao vien check in
    def teaching_checkin

      @sub_module         = 'teaching_checkin'
      @report_title_page  = t('report.report') + " " + t('report.report_teaching_checkin_title')

      param_form = Report::ReportService.form_paramater(params, request)

      string_date_format_dmy  = param_form['string_date_format_dmy']
      string_date_format_ymd  = param_form['string_date_format_ymd']
      sql_date_format_ymd     = param_form['sql_date_format_ymd']
      sql_date_format_dmy     = param_form['sql_date_format_dmy']
      company_id              = param_form['frm_report'][:company_id]
      report_type             = param_form['frm_report'][:report_type]

      from_date = param_form['frm_report'][:from_date]
      to_date   = param_form['frm_report'][:to_date]

      # form
      @frm_report         = param_form['frm_report']
      @labels             = param_form['labels']
      @list_data_table    = []

      # tieu de cua chart
      @report_title_chart  = t("report.report_" + report_type + "_title")

      # convert format for query param sql
      sql_from_date = Date.parse(from_date).strftime(string_date_format_ymd).to_s
      sql_to_date   = Date.parse(to_date).strftime(string_date_format_ymd).to_s

      @style = ''
      
      if company_id <= 0
        @js_data_template     = 'report/teaching/js/range_js_data_all_company'
        @table_data_template  = 'report/partials/list_company'
        @style = "style='min-height: 1000px; width: 100%;'"
      else
        @js_data_template     = 'report/teaching/js/range_js_data_single_company'
        @table_data_template  = 'report/partials/list_teacher'

        # Danh sach giao vien
        @list_data_table = Report::ReportService.statistic_teacher_checkin company_id,sql_date_format_ymd,sql_date_format_dmy,sql_from_date, sql_to_date

      end      

      # Danh sach check in ; not check in
      @list_data = Report::ReportService.statistic_teaching_checkin_range company_id,sql_date_format_ymd,sql_date_format_dmy,sql_from_date, sql_to_date

      respond_to do |format|
        format.html { render 'report/teaching_checkin'}
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

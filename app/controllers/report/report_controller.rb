module Report
  class ReportController < ApplicationController
    skip_before_action :verify_authenticity_token

    # Bao cao chuyen can
    def diligent
		@report_title_page = t('report.report_diligent_title')
      
		@params     = []
		@list_date  = []
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

			#if report_type == 'year'
			  #sql_date_format_ymd    = 'YYYY'
			#elsif report_type == 'month'
			  #sql_date_format_ymd    = 'YYYYMM'
			#end

			from_date = Date.parse(params[:frm_report][:from_date].to_s).is_a?(Date) ? params[:frm_report][:from_date].to_s : current_date
			to_date   = Date.parse(params[:frm_report][:to_date].to_s).is_a?(Date) ? params[:frm_report][:to_date].to_s : current_date

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
             @list_date = (Date.parse(from_date).strftime(string_date_format_ymd).to_s .. Date.parse(to_date).strftime(string_date_format_ymd).to_s).to_a
  				elsif report_type == 'month'
  				  string_date_format_ymd  = '%Y%m'
            string_date_format_dmy  = '%m-%Y'
            sql_date_format_dmy     = 'MM-YYYY'
            
            date_range = (Date.parse(from_date) .. Date.parse(to_date)).map {|d| Date.new(d.year, d.month, 1) }.uniq
              
            @list_date = date_range.map {|d| d.strftime(string_date_format_dmy).to_s}
          elsif report_type == 'week'
            
            date_range = (Date.parse(from_date)..Date.parse(to_date)).step(7).map(&:to_s)
              
            date_range = (Date.parse(from_date)..Date.parse(to_date)).step(7).map {|d| d.strftime("%U").to_s}
            
            puts date_range
             
  				end
			  end
			end
		end
      
			# convert format for query param sql
			sql_from_date = Date.parse(from_date).strftime(string_date_format_ymd).to_s
			sql_to_date = Date.parse(to_date).strftime(string_date_format_ymd).to_s
		  
			# get list company
			@list_company = Common::ResCompany.where.not(:id => [3,19,36,10,11,17,12,13,18,16]).select(:id, :name).order(code: :DESC)
		  
			@data_company = []
			data = []
			data_temps = []

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
				# Danh sach di hoc
				@list_present = Learning::Batch::OpSessionStudent.where(:company_id => company_id).where("op_session_student.present IS true AND (TO_CHAR(op_session_student.start_datetime, '#{sql_date_format_ymd}') >=  '#{sql_from_date}' AND TO_CHAR(op_session_student.start_datetime, '#{sql_date_format_ymd}') <=  '#{sql_to_date}')")
				.select("op_session_student.company_id as id, '' as name, count(op_session_student.id) as cnt_present, TO_CHAR(op_session_student.start_datetime, '#{sql_date_format_dmy}') as date_report_ymd ,TO_CHAR(op_session_student.start_datetime, '#{sql_date_format_dmy}') as date_report")
				.group('op_session_student.company_id,date_report_ymd')
				.order("date_report_ymd")
			  
				# Danh sach nghi hoc
				@list_no_present = Learning::Batch::OpSessionStudent.where(:company_id => company_id).where("op_session_student.present IS false AND (TO_CHAR(op_session_student.start_datetime, '#{sql_date_format_ymd}') >=  '#{sql_from_date}' AND TO_CHAR(op_session_student.start_datetime, '#{sql_date_format_ymd}') <=  '#{sql_to_date}')")
				.select("op_session_student.company_id as id, '' as name, count(op_session_student.id) as cnt_present, TO_CHAR(op_session_student.start_datetime, '#{sql_date_format_dmy}') as date_report_ymd ,TO_CHAR(op_session_student.start_datetime, '#{sql_date_format_dmy}') as date_report")
				.group('op_session_student.company_id,date_report_ymd')
				.order("date_report_ymd")
			  
				for present in @list_present
					for no_present in @list_no_present
						if (present.date_report == no_present.date_report)
							scale_present = (present.cnt_present.to_i == 0 && no_present.cnt_present.to_i==0) ? 0 : 100*present.cnt_present.to_i/(present.cnt_present.to_i + no_present.cnt_present.to_i)
							data_temps << {
								id: present.date_report || '',
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
			  
				data_coms = []
			  
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

				i = 0
				for data_com in data_coms
					for data_temp in data_temps
						if data_temp[:id].to_s == data_com[:id].to_s
							scale_present = (data_temp[:student_present] == 0 && data_temp[:student_no_present] == 0) ? 0 : 100*data_temp[:student_present]/(data_temp[:student_present] + data_temp[:student_no_present])
							data_coms[i] = {
								id: data_temp[:id],
								name: data_temp[:name] || '',
								student_present: data_temp[:student_present],
								student_no_present: data_temp[:student_no_present],
								scale_present: scale_present,
								scale_no_present: (data_temp[:student_present] == 0 && data_temp[:student_no_present] == 0) ? 0 : (100 - scale_present).to_i,
								presentBackgroundColor: (data_temp[:student_present] == 0 && data_temp[:student_no_present] == 0) ? 'transparent' : 'rgb(54, 162, 235)',
								noPresentBackgroundColor: (data_temp[:student_present] == 0 && data_temp[:student_no_present] == 0) ? 'transparent' : 'rgb(201, 203, 207)'
							}
						end
						#data_temps.delete(data_temp)
					end
					i = i+1
				end
				
        #puts data_temps

				#puts data_coms
				
				@data_company = data_coms			  
			end
      
      #@list_present.inspect
      
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

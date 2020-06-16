module Report
  class ReportController < ApplicationController
    skip_before_action :verify_authenticity_token
    
    # Bao cao chuyen can
    def diligent
      @report_title_page = t('report.report_diligent_title')

      #@list_company = Common::ResCompany.where.not(:id => [3,19,36,10,11,17,12,13,18,16]).select(:id, :name)
      
      current_date_format = Time.now.strftime("%d-%m-%Y").to_s
      
      @params = []
      @list_date = []
      
      from_date = to_date = Time.now.strftime("%Y%m%d").to_s
      @frm_report = {'from_date': from_date,'to_date': to_date}
      
      
        
      if request.method == 'POST'
        #binding.pry
        @params   = params
        
        #from_date = params[:frm_report][:from_date].to_s != '' ? params[:frm_report][:from_date].to_s : current_date_format        
        #to_date   = params[:frm_report][:to_date].to_s != '' ? params[:frm_report][:to_date].to_s : current_date_format
          
        from_date = Date.parse(params[:frm_report][:from_date].to_s).is_a?(Date) ? params[:frm_report][:from_date].to_s : current_date_format                    
        to_date   = Date.parse(params[:frm_report][:to_date].to_s).is_a?(Date) ? params[:frm_report][:to_date].to_s : current_date_format
        
        to_date = Date.parse(from_date).strftime('%Y%m%d').to_s > Date.parse(to_date).strftime('%Y%m%d').to_s ? from_date : to_date
        
        @frm_report = {
          'from_date': from_date,
          'to_date': to_date,
          'company_id': params[:frm_report][:company_id].to_i <= 0 ? params[:frm_report][:company_id].to_i : 0
        }
        
        date_range = Date.parse(from_date) .. Date.parse(to_date)
        
        @list_date = date_range.to_a.map { |e|e.strftime('%d-%m-%Y').to_s }
          
        from_date = Date.parse(from_date).strftime('%Y%m%d').to_s
        to_date   = Date.parse(to_date).strftime('%Y%m%d').to_s        
        
      end
      
      
      #current_date = '201912'
    
      # Danh sach di hoc
      @list_present = Common::ResCompany
      .joins("left join op_session_student as ss ON (res_company.id = ss.company_id AND ss.present IS true AND (TO_CHAR(ss.start_datetime, 'YYYYMMDD') >=  '#{from_date}' AND TO_CHAR(ss.start_datetime, 'YYYYMMDD') <=  '#{to_date}'))")
      .where.not(:id => [3,19,36,10,11,17,12,13,18,16])
      .select('res_company.id as id, res_company.name as name, count(ss.id) as cnt_present')
      .group('res_company.id, ss.company_id')
      .order(code: :DESC)
      
      # Danh sach nghi hoc
      @list_no_present = Common::ResCompany
      .joins("left join op_session_student as ss ON (res_company.id = ss.company_id AND ss.present IS false AND (TO_CHAR(ss.start_datetime, 'YYYYMMDD') >=  '#{from_date}' AND TO_CHAR(ss.start_datetime, 'YYYYMMDD') <=  '#{to_date}'))")
      .where.not(:id => [3,19,36,10,11,17,12,13,18,16])
      .select('res_company.id as id, res_company.name as name, count(ss.id) as cnt_present')
      .group('res_company.id, ss.company_id')
      .order(code: :DESC)
      
      #@list_present.inspect
      
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
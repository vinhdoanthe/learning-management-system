class User::OpTeachersService
	def self.filter_batch(teacher, params)
		@batchs ||= teacher.op_batchs
		query = ''
		if params[:active]
			query += "active = '#{params[:active]}' AND "
		else
			query += "active = true AND "
		end

		if params[:start_date]
			query += "start_date >= '#{params[:start_time].to_time.utc.strftime('%Y-%m-%d %H:%M:%S')}' AND "
		else
			query += "start_date >= '#{(Time.now - 7.days).to_time.utc.strftime('%Y-%m-%d %H:%M:%S')}' AND "
		end

		if params[:end_date] && params[:end_date].to_time <= Time.now
			query += "end_date <= '#{params[:end_time].to_time.utc.strftime('%Y-%m-%d %H:%M:%S')}' AND "
		end

		query += "company_id = '#{params[:company_id]}'" unless params[:company_id].blank? || params[:company_id] == 'all' 
		
		query = query[0..-5]
		@class = @batchs.where(query)
	end
end
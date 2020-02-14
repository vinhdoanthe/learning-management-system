class User::OpTeachersService
	def self.filter_batch(teacher, params)
		@batches ||= teacher.op_batches
		query = ''
		if params[:active] && params[:active] != 'all'
			query += "active = '#{params[:active]}' AND "
		end
		if params[:start_date]
			query += "start_date >= '#{params[:start_time].to_time.utc.strftime('%Y-%m-%d %H:%M:%S')}' AND "
		else
			query += "start_date >= '#{(Time.now - 1000.days).to_time.utc.strftime('%Y-%m-%d %H:%M:%S')}' AND "
		end

		if params[:end_date] && params[:end_date].to_time <= Time.now
			query += "end_date <= '#{params[:end_time].to_time.utc.strftime('%Y-%m-%d %H:%M:%S')}' AND "
		end

		query += "op_batch.company_id = #{params[:company]} AND " unless params[:company].blank? || params[:company] == 'all' 
		query = query[0..-5]
		@class = @batches.where(query)
	end
end
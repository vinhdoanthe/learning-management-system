class User::OpTeachersService
	def self.filter_batch(teacher, params)
		@batches ||= teacher.op_batches
		query = ''

		if params[:active] && params[:active] != 'all'
			query += "active = '#{params[:active]}' AND "
		end

		query += "op_batch.company_id = #{params[:company]} AND " unless params[:company].blank? || params[:company] == 'all' 
		query = query[0..-5]
		total_class = @batches.where(query)

		if params[:start_date]
			@class = total_class.where.not('start_date >= ? OR end_date <= ?', params[:end_date].to_time.utc.strftime('%Y-%m-%d'), params[:start_date].to_time.utc.strftime('%Y-%m-%d'))
		else
			query = "start_date >= '#{(Time.now - 1000.days).to_time.utc.strftime('%Y-%m-%d')}'"
			@class = total_class.where(query)
		end
		@class
	end
end
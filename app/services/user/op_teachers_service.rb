class User::OpTeachersService
  include Rails.application.routes.url_helpers

  def self.filter_batch(teacher, batches, params)
    @batches = batches
    return [] if @batches.blank?

    query = ''

    if params[:active] && params[:active] != 'all'
      if params[:active] == 'true'
        query += "active = true AND "
      else
        query += "active = false AND "
      end
    end

    query += "op_batch.company_id = #{params[:company]} AND " unless params[:company].blank? || params[:company] == 'all'
    query = query[0..-5]
    total_class = @batches.where(query)

    if params[:start_date].present?
      @class = total_class.where.not('start_date >= ? OR end_date <= ?', params[:end_date].to_time.utc.strftime('%Y-%m-%d'), params[:start_date].to_time.utc.strftime('%Y-%m-%d'))
    else
      query = "start_date >= '#{(Time.now - 1000.days).to_time.utc.strftime('%Y-%m-%d')}'"
      @class = total_class.where(query)
    end
    @class.uniq
  end

  def self.teaching_schedule session_list, params

    if params[:date].present?
      if session_list.kind_of?(Array)
        sessions = []
        session_list.each {|list| sessions << list.where(:start_datetime => params[:date].to_time.all_week)}
      else
        sessions = session_list.where(:start_datetime => params[:date].to_time.all_week)
      end
    else
      if session_list.kind_of?(Array)
        sessions = []
        session_list.each {|list| sessions << list.where(:start_datetime => Time.now.all_week)}
      else
        sessions = session_list.where(:start_datetime => Time.now.all_week)
      end
    end

    sessions = sessions.to_a
    sessions.flatten!
    sessions.select! {|session| session if session.present?}
    schedule_hash = {'s1' => {}, 's2' => {}, 'c1' => {}, 'c2' => {}, 't1' => {}, 't2' => {}}

    sessions.each do |session|
      time = session.end_datetime
      name = session.op_subject.name
      start_time = session.start_datetime.strftime('%H:%M')
      end_time = time.strftime('%H:%M')
      day = time.strftime('%Y-%m-%d')
      company = Common::ResCompany.find(session.company_id).name
      subject = session.op_subject.name
      level = session.op_subject.level.to_s
      batch = session.op_batch
      batch_name = batch.name
      faculty = session.op_faculty ? session.op_faculty.full_name : ""
      classroom = session.classroom_id.nil? ? '' : Common::OpClassroom.find(session.classroom_id).name

      batch_class_online = session.op_batch.company_id == 35 ? true : false
      # batch_class = session.op_batch.is_online_class
      course = session.op_batch.op_course.name
      lesson = session.op_batch.current_session_level
      status = session.state

      session_info = { batch_class_online: batch_class_online, name: name, start_time: start_time, end_time: end_time, day: day, company: company, subject: subject, level: level, batch: batch_name, course: course, lesson: lesson, status: status, faculty: faculty, classroom: classroom}
      record = { time.wday => session_info}
      record[7] = record[0]

      case time.hour.to_i
      when 8..10
        schedule_hash['s1'].merge!(record)
      when 10..12
        schedule_hash['s2'].merge!(record)
      when 12..14
        schedule_hash['c1'].merge!(record)
      when 14..16
        schedule_hash['c2'].merge!(record)
      when 16..18
        schedule_hash['t1'].merge!(record)
      when 18..20
        schedule_hash['t2'].merge!(record)
      else
        # type code here
      end
    end

    schedule_hash
  end

end

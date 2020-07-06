class Learning::Batch::Report::SubjectStudentAttendanceReport
  attr_accessor :sessions
  attr_accessor :student_id
  attr_accessor :tobe
  attr_accessor :cancelled
  attr_accessor :present_yes
  attr_accessor :present_no

  def initialize subject_id = nil, student_id = nil , sessions = []
    @subject_id = subject_id
    @student_id = student_id
    @sessions = sessions

    caculate_report
  end

  private
  def caculate_report
    @tobe = 0
    @cancelled = 0
    @present_yes = 0
    @present_no = 0
    if sessions.empty? or student_id.nil?
      # do nothing
    else
      sessions.each do |session|
        if session.tobe?
          @tobe += 1
        elsif session.cancelled?
          @cancelled += 1
        elsif session.done?
          if Learning::Batch::OpSessionsService.is_present?(session.id, student_id)
            @present_yes += 1
          else
            @present_no += 1
          end
        end
      end
    end
  end

end

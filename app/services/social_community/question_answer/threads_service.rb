module SocialCommunity::QuestionAnswer
  class ThreadsService
    include Constants

    # params {
    # session_id
    # lesson_id
    # subject
    # }
    def self.create_thread params, created_user
      return nil if params[:subject].empty? or created_user.nil?
      lesson_id = params[:lesson_id]
      session_id = params[:session_id]

      thread = SocialCommunity::QuestionAnswer::Thread.new
      thread.subject = params[:subject].to_s
      unless session_id.nil?
        thread.session_id = session_id
        session = Learning::Batch::OpSession.where(id: session_id).first
        unless session.nil?
          thread.course_id = session.course_id
          thread.batch_id = session.batch_id
          thread.subject_id = session.subject_id
        end  
      end
      unless lesson_id.nil?
        thread.lesson_id = lesson_id
      end
      
      thread.created_by = created_user.id
      thread.permission = PERMISSION_PUBLIC 
      if thread.save!
        create_notifications(thread, 'qa_thread.create')
        thread
      else
        nil
      end
    end
    
    def self.create_notifications thread, key
      thread.notify :users, key: key
    end

    # params {
    # user
    # start_time
    # end_time
    # session_id
    # lesson_id
    # subject_id
    # batch_id
    # course_id
    # }
    def self.get_threads params, user
      if params[:session_id].present? and user.present?
        SocialCommunity::QuestionAnswer::Thread.where(session_id: params[:session_id].to_i,
                                                      created_by: user.id)
          .order(updated_at: :DESC)
          .only(:session_id, :subject, :created_by, :created_at, :updated_at)
      else # TODO using more params
        []
      end  
    end

    def self.all_threads params, user
      SocialCommunity::QuestionAnswer::Thread.where(created_by: user.id)
        .order(updated_at: :DESC)
        .page(params[:page])
    end

    def self.get_faculty_user thread
      session = Learning::Batch::OpSession.where(id: thread.session_id).first
      if session.nil?
       nil
      else
        User::Account::User.where(faculty_id: session.faculty_id).first
      end 
    end
  end
end

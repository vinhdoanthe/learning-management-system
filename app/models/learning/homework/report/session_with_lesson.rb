module Learning
  module Homework
    module Report
      class SessionWithLesson
        attr_accessor :session_id
        attr_accessor :lesson_id
        attr_accessor :lesson_number

        def initialize(session_id = nil,
                       lesson_id = nil,
                       lesson_number = nil)
          @session_id = session_id
          @lesson_id = lesson_id
          @lesson_number = lesson_number
        end
      end
    end
  end
end

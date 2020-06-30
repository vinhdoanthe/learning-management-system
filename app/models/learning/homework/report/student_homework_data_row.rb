module Learning
  module Homework
    module Report
      class StudentHomeworkDataRow
        attr_accessor :student_id
        attr_accessor :student_name
        attr_accessor :count_homework_state

        def initialize(student_id = nil, 
                       student_name = nil,
                       count_homework_state = [])
          @student_id = student_id
          @student_name = student_name
          @count_homework_state = count_homework_state
        end
      end
    end
  end
end

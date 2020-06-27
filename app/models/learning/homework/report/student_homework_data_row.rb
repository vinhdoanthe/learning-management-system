module Learning
  module Homework
    module Report
      class StudentHomeworkDataRow
        attr_accessor :student_id
        attr_accessor :student_name
        attr_accessor :count_done
        attr_accessor :count_total

        def initialize(student_id = nil, 
                       student_name = nil,
                       count_done = nil,
                       count_total = nil)
          @student_id = student_id
          @student_name = student_name
          @count_done = count_done
          @count_total = count_total
        end
      end
    end
  end
end

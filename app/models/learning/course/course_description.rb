module Learning
  module Course
    class CourseDescription < ApplicationRecord
      self.table_name = 'course_description'
      
      belongs_to :op_course, foreign_key: :op_course_id, inverse_of: :course_description
    end
  end
end

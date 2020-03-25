module Learning
  module Course
    module OpCoursesHelper
      def get_description(course)
        return '' if course.nil?
        course_descriptions = course.course_description
        # binding.pry
        return '' if course_descriptions.nil?
        course_description = course_descriptions[0]
        if course_description.nil?
          return ''
        else
          return course_description.description
        end
      end
    end
  end
end

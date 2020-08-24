module Learning
  module Course
    module OpCoursesHelper
      def get_description(course)
        return '' if course.nil?
        
        course_descriptions = course.course_description
        return '' if course_descriptions.nil?
        
        course_description = course_descriptions[0]
        if course_description.nil?
          return ''
        else
          return course_description.description
        end
      end

      # get status of course
      def get_html_status(status)
        
        return status  == true ? '<span class="badge badge-success">' + t("button.Active") + '</span>' : '<span class="badge badge-warning">' + t("button.Unactive") + '</span>'        

      end #end functions

    end
  end
end

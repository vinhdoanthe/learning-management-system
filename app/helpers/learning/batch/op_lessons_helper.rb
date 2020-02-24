module Learning
  module Batch
    module OpLessonsHelper
      def thumbnail_tag lesson
        if !lesson.nil? && lesson.thumbnail.attached? 
          image_tag(lesson.thumbnail.variant(resize_to_limit: [130, 82])) 
        else 
          image_tag('default_lesson_thumbnail.jpg', size: "130x82") 
        end 
      end
    end
  end
end
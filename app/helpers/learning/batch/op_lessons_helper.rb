module Learning
  module Batch
    module OpLessonsHelper
      def thumbnail_tag lesson
        if !lesson.nil? && lesson.thumbnail.attached? 
          image_tag(lesson.thumbnail.variant(resize_to_limit: [130, 82])) 
        else 
          image_tag('global/images/default-lesson-thumbnail.png', size: "130x82")
        end 
      end
    end
  end
end
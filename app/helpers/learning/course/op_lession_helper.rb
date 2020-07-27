module Learning
  module Course
    module OpLessionHelper
      def get_teaching_materials(lesson_id)
        Learning::Material::LearningMaterial.where(op_lession_id: lesson_id,
                                                   material_type: Learning::Constant::Material::MATERIAL_TYPE_FILE,
                                                   learning_type: Learning::Constant::Material::MATERIAL_TYPE_TEACH).to_a
      end

      def get_review_videos(lesson_id)
        Learning::Material::LearningMaterial.where(op_lession_id: lesson_id,
                                                   material_type: Learning::Constant::Material::MATERIAL_TYPE_VIDEO,
                                                   learning_type: Learning::Constant::Material::MATERIAL_TYPE_REVIEW).to_a
      end
      def thumbnail_tag lesson
        if !lesson.nil? && lesson.thumbnail.attached? 
          image_tag(lesson.thumbnail.variant(resize_to_limit: [130, 80])) 
        else 
          image_tag('global/images/default-lesson-thumbnail.png', size: "130x80")
        end
      end

      def count_question lession_id
        Learning::Material::Question.where(op_lession_id: lession_id).count
      end

      def count_slides lession_id
        Learning::Material::LearningMaterial.where(op_lession_id: lession_id, 
                                                   material_type: Learning::Constant::Material::MATERIAL_TYPE_FILE,
                                                   learning_type: Learning::Constant::Material::MATERIAL_TYPE_TEACH).count
      end

      def count_videos lession_id
        Learning::Material::LearningMaterial.where(op_lession_id: lession_id, 
                                                   material_type: Learning::Constant::Material::MATERIAL_TYPE_VIDEO,
                                                   learning_type: Learning::Constant::Material::MATERIAL_TYPE_REVIEW).count

      end 
    end
  end
end

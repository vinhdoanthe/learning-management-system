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
    end
  end
end

module Learning
  module Course
    class OpLession < ApplicationRecord
      self.table_name = 'op_lession'

      belongs_to :op_subject, foreign_key: :subject_id
      
      has_many :learning_materials, class_name: 'Learning::Material::LearningMaterial', inverse_of: :op_lession
      accepts_nested_attributes_for :learning_materials, allow_destroy: true
      has_many :questions, class_name: 'Learning::Material::Question', inverse_of: :op_lession
      accepts_nested_attributes_for :questions, allow_destroy: true
      has_one_attached :thumbnail

      def op_course_name
        unless op_subject.nil?
          op_course = op_subject.op_course
          unless op_course.nil?
            op_course.name
          end
        end
      end

      def course_category
        unless op_subject.nil?
          op_course = op_subject.op_course
          unless op_course.nil?
            course_categ = op_course.course_categ
            unless course_categ.nil?
              course_categ.name
            end
          end
        end
      end

    end
  end
end

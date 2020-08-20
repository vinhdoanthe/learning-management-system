module Learning
  module Course
    class OpCourse < ApplicationRecord
      
      validates :short_description, presence: true, length: {minimum: 1,maximum: 255, allow_nil: false, message: I18n.t('adm.course.Not mull and maxlength 255 char')}

      include Rails.application.routes.url_helpers
      self.table_name = 'op_course'
      
      belongs_to :course_categ, foreign_key: 'categ_id', required: false

      has_many :op_batches, class_name: 'Learning::Batch::OpBatch', foreign_key: 'course_id'
      
      has_many :op_course_op_subject_rels, class_name: 'Learning::Course::OpCourseOpSubjectRel', foreign_key: 'op_course_id'
      has_many :op_subjects, through: :op_course_op_subject_rels, class_name: 'Learning::Course::OpSubject'
      has_many :op_sessions, class_name: 'Learning::Batch::OpSession', foreign_key: 'course_id'

      has_many :course_description, foreign_key: :op_course_id, inverse_of: :op_course
      accepts_nested_attributes_for :course_description, allow_destroy: true

      has_one_attached :thumbnail
      has_many_attached :equipment_logos
      
      def link
        learning_show_course_path(self.id)
      end
    end
  end
end

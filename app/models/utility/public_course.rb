class Utility::PublicCourse < ApplicationRecord
  validates :course_id, :presence => true
  validates_uniqueness_of :course_id
  belongs_to :op_course, :class_name => 'Learning::Course::OpCourse', :foreign_key => 'course_id'
end

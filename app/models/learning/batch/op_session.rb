module Learning
  module Batch
    class OpSession < ApplicationRecord
      self.table_name = 'op_session'
      self.inheritance_column = 'object_type'

      attr_accessor :remove_photos
      after_save do
        Array(remove_photos).each {|id| photos.find_by_id(id).try(:purge)}
      end

      belongs_to :op_faculty, :class_name => 'User::OpenEducat::OpFaculty', foreign_key: 'faculty_id'
      belongs_to :op_batch, :class_name => 'Learning::Batch::OpBatch', foreign_key: 'batch_id'
      belongs_to :op_subject, :class_name => 'Learning::Course::OpSubject', foreign_key: 'subject_id'
      belongs_to :op_lession, :class_name => 'Learning::Course::OpLession', foreign_key: 'lession_id', required: false
      belongs_to :op_classroom, :class_name => 'Common::OpClassroom', foreign_key: 'classroom_id', required: false

      has_many :op_session_students, :class_name => 'Learning::Batch::OpSessionStudent', foreign_key: 'session_id'
      has_many :op_attendance_sheets, :class_name => 'Learning::Batch::OpAttendanceSheet', foreign_key: 'session_id'
      has_many :op_attendance_lines, :class_name => 'Learning::Batch::OpAttendanceLine', foreign_key: 'session_id'
      has_many :photos, :class_name => 'SocialCommunity::Photo', foreign_key: 'session_id'

      def start_time
        self.start_datetime
      end

      def end_time
        end_datetime
      end

      def batch_code
        op_batch.code
      end

      def lesson
        att_sheet = op_attendance_sheets.last
        if att_sheet.nil?
          ''
        else
          if att_sheet.lession_id
            lesson = Learning::Course::OpLession.find(att_sheet.lession_id)
            if lesson.nil?
              ''
            else
              lesson.lession_number
            end
          else
            ''
          end
        end
      end

      def photos_link
        att_sheet = op_attendance_sheets.last
        if att_sheet.nil?
          ''
        else
          att_sheet.picture_link
        end
      end

      def done?
        return (state == Learning::Constant::Batch::Session::STATE_DONE)
      end

      def tobe?
        return (state == Learning::Constant::Batch::Session::STATE_DRAFT \
               or state == Learning::Constant::Batch::Session::STATE_CONFIRM)

      end

      def cancelled?
        return (state == Learning::Constant::Batch::Session::STATE_CANCEL)
      end
    end
  end
end

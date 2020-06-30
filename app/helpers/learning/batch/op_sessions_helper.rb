module Learning
  module Batch
    module OpSessionsHelper
      def attendance_line(session_id, student_id)
        Learning::Batch::OpAttendanceLine.where(session_id: session_id, student_id: student_id).last
      end

      def get_lesson_of_session op_session
        if op_session.lession_id.nil?
          att_sheet = op_session.op_attendance_sheets.last
          if att_sheet.nil?
            nil
          else
            Learning::Course::OpLession.where(id: att_sheet.lession_id).first
          end
        else
          op_session.op_lession
        end
      end 

      def get_video_thumbnail op_session
        session_video = Learning::Material::LearningMaterial.where(material_type: Learning::Constant::Material::MATERIAL_TYPE_VIDEO, :op_lession_id => op_session.lession_id).order(created_at: :DESC).first if session.present?
        if session_video.present?
          if session_video.thumbnail_image.attached?
            url = url_for(session_video.thumbnail_image)
          end
        else
          url = image_path 'video-camera-icon-1.png'
        end
        url
      end


      def is_online_session? session
        result = false
        unless session.nil?
          batch = session.op_batch
          unless batch.nil?
            result = batch.is_online? 
          end
        end
        result 
      end
    end
  end
end

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
        url = ''
        session_video = Learning::Material::LearningMaterial.where(material_type: Learning::Constant::Material::MATERIAL_TYPE_VIDEO, :op_lession_id => op_session.lession_id).order(created_at: :DESC).first if session.present?
        if session_video.present?
          if session_video.thumbnail_image.attached?
            url = url_for(session_video.thumbnail_image)
          end
        end

        url = image_path 'video-camera-icon-1.png' if url.blank?

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

      def get_session_has_video sessions
        list_sessions = sessions.select{|s| s.lession_id != nil}
        return [] if list_sessions.blank?

        sessions_has_video = []

        list_sessions.each do |session|
          lesson = session.op_lession
          has_video = Learning::Material::LearningMaterial.where(material_type: 'video', op_lession_id: lesson.id).first.present?
          sessions_has_video << session if has_video
        end

        sessions_has_video
      end

      def css_class_name state

        if state == Learning::Constant::Batch::Session::STATE_DRAFT
          class_name = 'warning'
        elsif state == Learning::Constant::Batch::Session::STATE_CONFIRM
          class_name = 'primary'
        elsif state == Learning::Constant::Batch::Session::STATE_DONE
          class_name = 'success'
        elsif state == Learning::Constant::Batch::Session::STATE_CANCEL
          class_name = 'secondary'
        end

        class_name
      end


      def state_label state

        if state == Learning::Constant::Batch::Session::STATE_DRAFT
          lbl_state = I18n.t('adm.learning.session.lbl_state_draft')
        elsif state == Learning::Constant::Batch::Session::STATE_CONFIRM
          lbl_state = I18n.t('adm.learning.session.lbl_state_confirm')
        elsif state == Learning::Constant::Batch::Session::STATE_DONE
          lbl_state = I18n.t('adm.learning.session.lbl_state_done')
        elsif state == Learning::Constant::Batch::Session::STATE_CANCEL
          lbl_state = I18n.t('adm.learning.session.lbl_state_cancel')
        end

        lbl_state
      end

    end
  end
end

module User
  module OpenEducat
    module OpStudentsHelper
      def pp_can_change_avatar?(op_student_id)
        if !current_user.nil? and current_user.is_student? and (current_user.student_id == op_student_id)
          true
        else
          false
        end
      end
    end
  end
end

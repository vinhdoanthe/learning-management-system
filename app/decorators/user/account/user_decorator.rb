class User::Account::UserDecorator < SimpleDelegator
  include ActionView::Helpers
  include Rails.application.routes.url_helpers

  def display_avatar size="auto"
    if avatar.present?
      "<span><img width=#{ size } src=#{ rails_blob_path(avatar.thumbnail, disposition: 'attachment', only_path: true)}></span>"
    else
      display_avatar_by_role size
    end
  end

  def display_avatar_by_role size
    if account_role == 'Student'
      if op_student.gender == 'm' 
      "<span>#{ image_tag(ActionController::Base.helpers.asset_path('global/images/Group-3.png'), width: size) }</span>"
      elsif op_student.gender == 'f' 
      "<span>#{ image_tag(ActionController::Base.helpers.asset_path('global/images/Group-5.png'), width: size) }</span>"
      else
      "<span>#{ image_tag(ActionController::Base.helpers.asset_path('global/images/icon-student.png'), width: size) }</span>"
      end
    elsif account_role == 'Teacher'
      "<span>#{ image_tag(ActionController::Base.helpers.asset_path('global/images/Bitmaps.png'), width: size) }</span>"
    elsif account_role == 'Parent'
      "<span>#{ image_tag(ActionController::Base.helpers.asset_path('global/images/avatars/avatar11_big.png'), width: size) }</span>"
    elsif account_role == 'Admin'
      "<span>#{ image_tag(ActionController::Base.helpers.asset_path('global/images/Bitmaps.png'), width: size) }</span>"

    end
  end
end

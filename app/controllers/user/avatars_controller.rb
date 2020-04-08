class User::AvatarsController < ApplicationController

  def avatars_list
    if params[:gender].present?
      avatars = User::Avatar.get_avatars_by_gender(params[:gender])     
      avatar_links = []
      avatars.each do |avatar|
        avatar_obj = {
          'id' => avatar.id,
          'thumbnail' => (avatar.thumbnail.attached? ? url_for(avatar.thumbnail) : ''),
          'full_size' => (avatar.full_size.attached? ? url_for(avatar.full_size) : '')
        }
        avatar_links << avatar_obj
        respond_to do |format|
          format.js { render 'user/op_students/modals/change_avatar', :locals => {avatars: avatar_links}}
        end
      end 
    end
  end

end

class User::Account::AvatarsController < ApplicationController
  before_action :get_avatar, only: [:show_fullsize]

  def avatars_list
    if params[:gender].present?
      avatars = User::Account::Avatar.get_avatars_by_gender(params[:gender])
      avatar_links = []
      avatars.each do |avatar|
        avatar_obj = {
          'id' => avatar.id,
          'thumbnail' => (avatar.thumbnail.attached? ? url_for(avatar.thumbnail) : ''),
          'full_size' => (avatar.full_size.attached? ? url_for(avatar.full_size) : '')
        }
        avatar_links << avatar_obj
      end 
      respond_to do |format|
        format.js { render 'user/open_educat/op_students/modal/change_avatar', :locals => {avatars: avatar_links}}
      end
    end
  end

  def show_fullsize
    respond_to do |format|
      format.html
      format.js { render 'user/open_educat/op_students/js/show_fullsize_in_pp', :locals => {avatar: @avatar}}
    end
  end

  private

  def get_avatar
    if params[:id].present?
      @avatar = User::Account::Avatar.where(id: params[:id].to_i).first
    else
      @avatar = nil
    end
  end
end

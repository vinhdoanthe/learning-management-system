class SocialCommunity::PhotoService
  def add_photo_attachment session, list_photos, user
    errors = ''
    batch = session.op_batch
    album = SocialCommunity::Album.where(batch_id: batch.id).first

    ActiveRecord::Base.transaction do
      album = create_new_album batch.id if album.blank?
      post = create_photo_post user, batch.id
      subscribed_users = SocialCommunity::Feed::PhotoPostsService.subscribed_users session.id
      SocialCommunity::Feed::UserPostsService.create_multiple post.id, subscribed_users
      SocialCommunity::Feed::UserPostsService.create_multiple post.id, [user.id]

      list_photos.each do |photo|
        create_new_photo session.id, album.id, photo, user, post
      end
      
      post.create_notifications
    end

    errors
  rescue StandardError => e
    puts e
    'Đã có lỗi xảy ra. Thử lại sau!'
  end

  def create_new_album batch_id
    album = SocialCommunity::Album.new
    album.batch_id = batch_id
    album.save!
    album
  end

  def create_new_photo session_id, album_id, image, user, post
    photo = SocialCommunity::Photo.new
    photo.album_id = album_id
    photo.session_id = session_id
    photo.created_by = user.id
    photo.sc_post_id = post.id
    photo.save!
    photo.image.attach(image)
    photo
  end

  def create_photo_post user, batch_id
    post = SocialCommunity::Feed::PhotoPost.new
    post.posted_by = user.id
    post.batch_id = batch_id
    post.save!
    post
  end

  def delete_photo photo_id
    photo = SocialCommunity::Photo.where(id: photo_id).first
    return { type: 'danger', message: 'Có lỗi xảy ra! Thử lại sau' } if photo.blank?
    post = photo.sc_post
    return { type: 'danger', message: 'Có lỗi xảy ra! Thử lại sau' } if post.blank?

    if post.photos.count > 1
      photo.delete
      return { type: 'success', message: 'Xoá ảnh thành công' }
    else
      photo.delete
      post.delete
      return { type: 'success', message: 'Xoá ảnh thành công' }
    end
  end
end

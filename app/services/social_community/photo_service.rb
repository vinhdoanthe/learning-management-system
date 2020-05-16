class SocialCommunity::PhotoService
  def add_photo_attachment session, list_photos, user
    errors = ''
    batch = session.op_batch
    album = SocialCommunity::Album.where(batch_id: batch.id).first

    ActiveRecord::Base.transaction do
      album = create_new_album batch.id if album.blank?
      post = create_photo_post user
      subscribed_users = SocialCommunity::Feed::PhotoPostsService.subscribed_users session.id
      SocialCommunity::Feed::UserPostsService.create_multiple post.id, subscribed_users

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

  def create_photo_post user
    post = SocialCommunity::Feed::PhotoPost.new
    post.posted_by = user.id
    post.save!
    post
  end
end

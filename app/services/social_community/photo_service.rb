class SocialCommunity::PhotoService
  def add_photo_attachment session, list_photos, user
    errors = ''
    batch = session.op_batch
    album = SocialCommunity::Album.where(batch_id: batch.id).first
    album = create_new_album batch.id if album.blank?

    list_photos.each do |photo|
      create_new_photo session.id, album.id, photo, user
    end

    errors
  rescue StandardError => e
    puts e
    errors = 'Đã có lỗi xảy ra. Thử lại sau!'
  end

  def create_new_album batch_id
    album = SocialCommunity::Album.new
    album.batch_id = batch_id
    album.save
    album
  end

  def create_new_photo session_id, album_id, image, user
    photo = SocialCommunity::Photo.new
    photo.session_id = session_id
    photo.album_id = album_id
    photo.created_by = user.id
    photo.save
    photo.image.attach(image)
  end
end

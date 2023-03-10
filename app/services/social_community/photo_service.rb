class SocialCommunity::PhotoService
  require 'mini_magick'
  require 'image_optim'

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
    # Process image
    processed_image = pre_process_image image
    photo = SocialCommunity::Photo.new
    photo.album_id = album_id
    photo.session_id = session_id
    photo.created_by = user.id
    photo.sc_post_id = post.id
    photo.save!
    # photo_file_name
    filename = "#{Time.now.to_i}.jpg" 
    photo.image.attach(io: File.open(processed_image.path), filename: filename)
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

  private

  # constraints
  # - max dimensions: 4K resolution 3840x2160
  # - max size in disk: 500 kB
  def pre_process_image image
    begin
      processed_image = MiniMagick::Image.new(image.tempfile.path)
      processed_image.format 'jpg'
      w,h = processed_image.dimensions
      max_w = 3840
      max_h = 2160
      if w > max_w or h > max_h
        if (w/max_w) < (h/max_h)
          new_h = max_h
          new_w = w*new_h/h
        else
          new_w = max_w
          new_h = h*new_w/w
        end
        new_dimensions="#{new_w}x#{new_h}" 
        processed_image.resize(new_dimensions)
      end
      processed_image.write processed_image.path
      image_size = processed_image.size
      max_quality = 100
      if image_size > 5000000
        max_quality = 50
      elsif image_size > 4000000
        max_quality = 60
      elsif image_size > 3000000
        max_quality = 70
      elsif image_size > 2000000
        max_quality = 80
      elsif image_size > 1000000
        max_quality = 85
      elsif image_size > 500000
        max_quality = 90
      elsif image_size > 300000
        max_quality = 95
      end
      # Optimize image
      image_optim = ImageOptim.new(:pack => true,
                                   :pngout => false,
                                   :advpng => false, 
                                   :nice => 20, 
                                   :allow_lossy => true,
                                   :jpegrecompress => false,
                                   :jpegtran => false,
                                   :jpegoptim => {
                                     :allow_lossy => true,
                                     :strip => :all,
                                     :max_quality => max_quality
                                   })
      image_optim.optimize_image!(processed_image.path)
      processed_image
    rescue Exception => e
      logger.fatal e.message
      e.backtrace.each { |line| logger.fatal line }
    end
  end
end

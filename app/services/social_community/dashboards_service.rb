class SocialCommunity::DashboardsService
 
  def self.get_student_albums_with_comments student_id
    albums_with_comments = []
    batch_ids = User::OpenEducat::OpStudentsService.get_batch_ids student_id
    batch_ids.each do |batch_id|
      album_with_comments = {}
      batch = Learning::Batch::OpBatch.where(id: batch_id).first
      next if batch.nil?
      batch_code = batch.code
      album = SocialCommunity::Album.where(batch_id: batch_id)
      next if album.nil?
      count_images, images = SocialCommunity::AlbumsService.get_photos(album.id)
      count_like, count_love, count_sad = SocialCommunity::AlbumsService.count_reactions(photo.id)
      comments = SocialCommunity::AlbunsService.get_comments(album.id)

      album_with_comments = {
        :id => album.id,
        :batch_code => batch_code,
        :count_images => count_images,
        :images => images,
        :count_like => count_like,
        :count_love => count_love,
        :count_sad => count_sad,
        :comments => comments
      }
      albums_with_comments << album_with_comments
    end

    albums_with_comments
  end 
end

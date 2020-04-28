class SocialCommunity::DashboardsService

  def self.get_student_albums_with_comments student_id
    albums_with_comments = []
    batch_ids = User::OpenEducat::OpStudentsService.get_batch_ids student_id
    batch_ids.each do |batch_id|
      album_with_comments = {}
      batch = Learning::Batch::OpBatch.where(id: batch_id).first
      next if batch.nil?
      batch_code = batch.code
      album = SocialCommunity::Album.where(batch_id: batch_id).first
      next if album.nil?
      count_images, images = SocialCommunity::AlbumsService.get_photos(album.id)
      count_like, count_love, count_sad = SocialCommunity::AlbumsService.count_reactions(album.id)
      comments = SocialCommunity::AlbumsService.get_comments(album.id)

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

  def self.coming_session_decorator session
    unless session.nil?
      batch = Learning::Batch::OpBatch.where(id: session.batch_id).first
      batch_code = batch.nil? ? '' : batch.code
      batch_id = batch.nil? ? nil : batch.id
      company = Common::ResCompany.where(id: session.company_id).first
      company_name = company.nil? ? '' : company.name
      {
        :batch_id => batch_id,
        :batch_code => batch_code,
        :company_name => company_name,
        :session => session
      }
    else
      nil
    end
  end
end

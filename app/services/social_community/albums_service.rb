class SocialCommunity::AlbumsService
  def self.get_photos album_id
    photos = SocialCommunity::Photo.where(album_id: album_id).to_a
    count = photos.size

    [count, photos]
  end

  def self.count_reactions album_id
    album = SocialCommunity::Album.where(id: album_id).first
    if album.nil?
      return [nil, nil, nil]
    else
      count_like = album.reactions.where(react_type: SocialCommunity::Constant::ReactionType::LIKE).count 
      count_love = album.reactions.where(react_type: SocialCommunity::Constant::ReactionType::LOVE).count
      count_sad = album.reactions.where(react_type: SocialCommunity::Constant::ReactionType::SAD).count
      return [count_like, count_love, count_sad]
    end
  end

  def self.count_like album_id
    album = SocialCommunity::Album.where(id: album_id).first
    if album.nil?
      nil
    else
      album.reactions.where(react_type: SocialCommunity::Constant::ReactionType::LIKE).count 
    end
  end

  def self.count_love album_id
    album = SocialCommunity::Album.where(id: album_id).first
    if album.nil?
      nil
    else
      album.reactions.where(react_type: SocialCommunity::Constant::ReactionType::LOVE).count 
    end
  end

  def self.count_sad album_id
    album = SocialCommunity::Album.where(id: album_id).first
    if album.nil?
      nil
    else
      album.reactions.where(react_type: SocialCommunity::Constant::ReactionType::SAD).count 
    end
  end

  def self.get_comments album_id
    album = SocialCommunity::Album.where(id: album_id).first
    album.comments.order(created_at: :DESC).to_a
  end
end

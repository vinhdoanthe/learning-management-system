namespace :social_community do
  desc 'Mapping old photos to PhotoPost'
  task :mapping_old_photos_to_photo_posts, [] => :environment do |t, args|
    session_ids = SocialCommunity::Photo.all.pluck(:session_id).uniq.compact
    session_count = session_ids.count
    puts "Total session: #{session_count}"
    count = 0
    photo_service = SocialCommunity::PhotoService.new
    session_ids.each do |session_id|
      count += 1
      puts "Working on #{count}/#{session_count}"
      session = Learning::Batch::OpSession.where(id: session_id).first
      photos = SocialCommunity::Photo.where(session_id: session_id, sc_post_id: nil).to_a
      user = User::Account::User.where(faculty_id: session.faculty_id).first
      ActiveRecord::Base.transaction do
        photo_post = photo_service.create_photo_post user
        subscribed_users = SocialCommunity::Feed::PhotoPostsService.subscribed_users session.id
        subscribed_users << user.id
        SocialCommunity::Feed::UserPostsService.create_multiple photo_post.id, subscribed_users
        photos.each do |photo|
          photo.update(sc_post_id: photo_post.id)
        end
        photo_post.create_notifications
      end
    end 
  end
end

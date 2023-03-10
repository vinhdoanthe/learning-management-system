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
      if !photos.empty? and !session.nil? and !user.nil?
        created_at = photos[0].created_at
        updated_at = photos[0].updated_at
        ActiveRecord::Base.transaction do
          photo_post = photo_service.create_photo_post user
          photo_post.update(created_at: created_at, updated_at: updated_at)
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

  desc 'Create session student reward post'
  task :create_session_student_reward_posts, [] => :environment do |t, args|
    count = Learning::Batch::SessionStudentReward.count
    Learning::Batch::SessionStudentReward.all.each_with_index do |reward, index|
      puts "Working on #{ index + 1}/#{ count }"
      session = Learning::Batch::OpSession.where(id: reward.session_id).first
      next if session.blank?
      if reward.sc_post_id.present?
        post = SocialCommunity::Feed::Post.where(id: reward.sc_post_id).first
        # next if (!post.blank? && post.batch_id.present?)
        unless post.nil?
          post.update(batch_id: session.batch_id)
          SocialCommunity::Feed::UserPostsService.create_multiple post.id, [reward.rewarded_to, reward.rewarded_by]
        end
      else
        ActiveRecord::Base.transaction do
          post = SocialCommunity::Feed::RewardPost.new
          post.posted_by = reward.rewarded_by
          post.batch_id = session.batch_id
          post.created_at = reward.created_at
          post.updated_at = Time.now
          post.save!
          reward.update!(sc_post_id: post.id)
          SocialCommunity::Feed::UserPostsService.create_multiple post.id, [reward.rewarded_to, reward.rewarded_by]
          post.create_notifications
          puts "Done #{ index + 1}/#{ count }"
        end
      end
    end
  end

  desc 'Update batch_id for post'
  task :update_batch_id_post, [] => :environment do |t, args|
    count = SocialCommunity::Feed::Post.count
    SocialCommunity::Feed::Post.all.each_with_index do |post, index|
      next if post.batch_id.present?
      session = ''
      if post.type == "SocialCommunity::Feed::RewardPost"
        reward = post.session_student_reward
        next if reward.blank?
        session = Learning::Batch::OpSession.where(id: reward.session_id).first
      elsif post.type == "SocialCommunity::Feed::PhotoPost"
        photo = post.photos.first
        next if photo.blank?
        session = Learning::Batch::OpSession.where(id: photo.session_id).first
      end

      next if session.blank?
      post.update(batch_id: session.batch_id)
      puts "Working on #{ index + 1}/#{ count }"
    end
  end

  desc 'Auto add reactions to posts'
  task :add_reactions_to_posts, [:prev_minutes, :offset_minutes] => :environment do |t, args|
    return if !args[:prev_minutes].present? or !args[:offset_minutes].present?
    prev_minutes = args[:prev_minutes].to_i
    offset_minutes = args[:offset_minutes].to_i
    return if (prev_minutes==0) or (offset_minutes==0)
    # find posts
    puts "prev_minutes #{prev_minutes}"
    puts "offset_minutes #{offset_minutes}"
    e_created_at = Time.now - prev_minutes.minutes
    s_created_at = e_created_at - offset_minutes.minutes
    puts "s_created_at #{s_created_at}"
    puts "e_created_at #{e_created_at}"

    posts = SocialCommunity::Feed::Post.where('created_at <= ? and created_at >= ? and type in (?)', e_created_at, s_created_at, PostConstants::NewfeedPostTypes::ACCEPTED_NEWFEED_POST_TYPES)
      .order(created_at: :DESC)
    size = posts.size
    puts "Total posts is #{size}"
    post_ids = posts.map {|post| post.id}
    generated_post_ids = Utility::TrackingAutoGenerateReactionToPost.in(post_id: post_ids).pluck(:post_id).uniq
    puts "post_ids #{post_ids}"
    puts "generated_post_ids #{generated_post_ids}"
    todo_post_ids = post_ids - generated_post_ids
    todo_posts = posts.select {|post| todo_post_ids.include?(post.id)}
    size = todo_posts.size
    puts "Total todo posts is #{size}"
    Utility::TrackingAutoGenerateReactionToPostService.create_new todo_posts
  end

  desc 'Create blank post'
  task :create_blank_post, [] => :environment do |t, args|
    blank_post = SocialCommunity::Feed::BlankPost.new
    admin_user = User::Account::User.where(account_role: Constant::ADMIN).first
    blank_post.posted_by = admin_user.id
    blank_post.save
  end
end

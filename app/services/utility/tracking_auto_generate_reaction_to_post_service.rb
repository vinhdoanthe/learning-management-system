class Utility::TrackingAutoGenerateReactionToPostService
  def self.create_new posts
    user_ids = User::Account::User.where(account_role: [User::Constant::TEACHER, User::Constant::STUDENT]).pluck(:id) 
    posts.each_with_index do |post, index|
      puts "Processing post #{index}"
      r_count_like = rand(30..100)
      r_count_love = rand(20..50)
      r_count_sad = rand(0..10)
      r_like_user_ids = user_ids.sample(r_count_like)
      r_love_user_ids = user_ids.sample(r_count_love)
      r_sad_user_ids = user_ids.sample(r_count_sad)
      content = {
        :count_like => r_count_like,
        :count_love => r_count_love,
        :count_sad => r_count_sad,
        :like_user_ids => r_like_user_ids,
        :love_user_ids => r_love_user_ids,
        :sad_user_ids => r_sad_user_ids
      }

      r_like_user_ids.each do |user_id|
        reaction = SocialCommunity::Reaction.new(:reacted_by => user_id,
                                     :react_type => SocialCommunity::Constant::ReactionType::LIKE,
                                     :reactable => post)
        reaction.save
      end

      r_love_user_ids.each do |user_id|
        reaction = SocialCommunity::Reaction.new(:reacted_by => user_id,
                                     :react_type => SocialCommunity::Constant::ReactionType::LOVE,
                                     :reactable => post)
        reaction.save
      end

      r_sad_user_ids.each do |user_id|
        reaction = SocialCommunity::Reaction.new(:reacted_by => user_id,
                                     :react_type => SocialCommunity::Constant::ReactionType::SAD,
                                     :reactable => post)
        reaction.save
      end

      tracking = Utility::TrackingAutoGenerateReactionToPost.new(:post_id => post.id,
                                                      :generated_content => content)
      tracking.save
      puts "Processing post #{index} done"
    end
  end
end

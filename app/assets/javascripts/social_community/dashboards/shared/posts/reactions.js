function addReaction(target){
  $(target).on('click', '.post-like-btn', function(event){
    event.preventDefault();
    data = {
      reaction_type: 1,
      post_id: $(this).data('post-id'),
      authenticity_token: $('[name="csrf-token"]')[0].content
    };
    add_reaction_to_post(data);
  });

  $(target).on('click', '.post-love-btn', function(event){
    event.preventDefault();
    data = {
      reaction_type: 2,
      post_id: $(this).data('post-id'),
      authenticity_token: $('[name="csrf-token"]')[0].content
    };
    add_reaction_to_post(data);
  });

  $(target).on('click', '.post-sad-btn', function(event){
    event.preventDefault();
    data = {
      reaction_type: 3,
      post_id: $(this).data('post-id'),
      authenticity_token: $('[name="csrf-token"]')[0].content
    };
    add_reaction_to_post(data);
  });
}
$(document).ready(function(){
  addReaction('#homeFeeds');
  addReaction('#newFeeds');
  // addReaction('#student_project_feed');
});

function add_reaction_to_post(data) {
  $.ajax({
    method: 'POST',
    data: data,
    url: '/social_community/feed/posts/add_reaction',
    dataType: 'script'
  })
}

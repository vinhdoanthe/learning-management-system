$(document).ready(function(){
  $('#homeFeeds').on('keyup', '.post-comment-input', function(event){
    if(event.key === 'Enter') {
      event.preventDefault();
      post_id = $(event.target).data('post-id')
      content = $("#post_comment_input_" + post_id).val()
      if (content) {
        data = {
          content: content,
          post_id: post_id,
          authenticity_token: $('[name="csrf-token"]')[0].content
        };
        add_comment_to_post(data);
      }
    }
  });

  $('#homeFeeds').click('.post-comment-btn', function(event){
    event.preventDefault();
    post_id = $(event.target).data('post-id')
    content = $("#post_comment_input_" + post_id).val()
    if (content) {
      data = {
        content: content,
        post_id: post_id,
        authenticity_token: $('[name="csrf-token"]')[0].content
      };
      add_comment_to_post(data);
    }
  });
});

function add_comment_to_post(data) {
  $.ajax({
    method: 'POST',
    data: data,
    url: '/social_community/feed/posts/add_comment',
    dataType: 'script'
  })
}
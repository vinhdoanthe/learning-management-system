$(document).ready(function(){
  function getReactionsAndComments(post_id){
    $.ajax({
      method: 'GET',
      url: '/social_community/feed/get_reactions_and_comments?post_id=' + post_id,
      dataType: 'script'
    })
  }
  
  post_id = $('input[name="sc_student_project_post_id"]').val();
  getReactionsAndComments(post_id)
})

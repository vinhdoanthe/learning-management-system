$(document).ready(function () {
  // Get initial posts
  get_feeds();
  
  // Listen to scroll action
  var position = $(window).scrollTop(); 
  $(window).on('scroll', function(){
    var scroll = $(window).scrollTop();
    if(scroll > position) {
      // TODO
      loadMorePosts();
    }
    position = scroll;
  })
});


function get_feeds() {
  $.ajax({
    method: 'GET',
    url: '/social_community/home_feeds',
    dataType: 'script'
  })
}

function loadMorePosts() {
  // Get next time offset
  date_time_offset = $('#infinitive-scrolling').attr('date-time-offset');
  console.log(date_time_offset)
  if (date_time_offset != 0  && $(window).scrollTop() > $('#homeFeeds').height() - $(window).height() - 100) {
  $('#infinitive-scrolling').attr('date-time-offset', '0');
    $.ajax({
      method: 'GET',
      url: '/social_community/home_feeds',
      data: {
        time_offset_epoch: date_time_offset,
        authenticity_token: $('[name="csrf-token"]')[0].content
      },
      dataType: 'script'
    }) 
  }
}

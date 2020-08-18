$(document).ready(function () {
  // Get initial posts

  get_new_feeds()  

  var position = $(window).scrollTop(); 
  $(window).on('scroll', function(){
    if ($('#tab_newFeeds').hasClass('active')) {
      var scroll = $(window).scrollTop();
      if(scroll > position) {
        load_more_new_feeds();
      }
      position = scroll;
    }
  })


  $('#li_newFeeds').on('click', function() {
    $('#newFeeds').html('')
    $('#homeFeeds').html('')
    get_new_feeds();
    var position = $(window).scrollTop(); 
    $(window).on('scroll', function(){
      if ($('#tab_newFeeds').hasClass('active')) {
        var scroll = $(window).scrollTop();
        if(scroll > position) {
          load_more_new_feeds();
        }
        position = scroll;
      }
    })
  })

  $('#li_homeFeeds').on('click', function(){
    $('#homeFeeds').html('')
    $('#newFeeds').html('')
    get_feeds();
    // Listen to scroll action
    var position = $(window).scrollTop(); 
    $(window).on('scroll', function(){
      if ($('#tab_homeFeeds').hasClass('active')) {
        var scroll = $(window).scrollTop();
        if(scroll > position) {
          loadMorePosts();
        }
        position = scroll;
      }
    })
  })


  $('#tab_newFeeds').on('click', '.show_dashboard_photo', function(){
    post_id = $(this).data('post');
    $.ajax({
      url: '/social_community/dashboard_photos?post_id=' + post_id,
      method: 'GET',
      dataType: 'script'
    })
  })
});

function get_feeds() {
  // console.log('load feeds called')
  $.ajax({
    method: 'GET',
    url: '/social_community/home_feeds',
    dataType: 'script'
  })
}

function loadMorePosts() {
  // Get next time offset
  date_time_offset = $('#infinitive-scrolling').attr('date-time-offset');
  // console.log(date_time_offset)
  if (date_time_offset != 0  && $(window).scrollTop() > $('#homeFeeds').height() - $(window).height() - 100) {
    $('#infinitive-scrolling').attr('date-time-offset', '0');
    //
    // render loading
    $('#loading-home-feeds').show();
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


function get_new_feeds() {
  // console.log('triggered new feeds load')
  $.ajax({
    method: 'GET',
    url: '/social_community/new_feeds',
    dataType: 'script'
  })
}

function load_more_new_feeds() {

  post_offset = $('#infinitive-scrolling-new-feeds').attr('post-offset');
  last_post_date_time = $('#infinitive-scrolling-new-feeds').attr('last-post-date-time');

  // console.log(post_offset);
  // console.log(last_post_date_time);

  if (last_post_date_time != 0  && $(window).scrollTop() > $('#newFeeds').height() - $(window).height() - 100) {
    $('#infinitive-scrolling-new-feeds').attr('last-post-date-time', '0');
    $('#infinitive-scrolling-new-feeds').attr('post-offset', 0);

    // render loading
    $('#loading-new-feeds').show();
    $.ajax({
      method: 'GET',
      url: '/social_community/new_feeds',
      data: {
        last_post_date_time: last_post_date_time,
        post_offset: post_offset,
        authenticity_token: $('[name="csrf-token"]')[0].content
      },
      dataType: 'script'
    }) 
  }
}


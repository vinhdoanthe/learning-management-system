$(document).ready(function () {

	get_feeds();
  
  more_posts_url = $('.pagination .next_page a').attr('href');
  // Load more posts if page is not scrollable
  if (more_posts_url && ($('#homeFeeds').height() < $(window).height())) {
    getNextPosts();
  }

  $(window).on('scroll', function(){
    loadMorePosts();
  })
});


function get_feeds() {
  console.log('Start load feeds')
  $.ajax({
    method: 'GET',
    url: '/social_community/home_feeds',
    dataType: 'script'
  })
}

function loadMorePosts() {
  more_posts_url = $('.pagination .next_page a').attr('href');
  if (more_posts_url && $(window).scrollTop() > $(document).height() - $(window).height() - 100) {
    console.log(more_posts_url);
    $('.pagination').html('<img src="/ajax-loader.gif" alt="Loading..." title="Loading..." />');
    $.getScript(more_posts_url);
  }
}

function getNextPosts() {
  console.log('Initialize posts to get enough for scrollable');
  more_posts_url = $('.pagination .next_page a').attr('href');
  if (more_posts_url) {
    $('.pagination').html('<img src="/ajax-loader.gif" alt="Loading..." title="Loading..." />');
    $.getScript(more_posts_url);
  }
}

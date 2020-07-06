$(document).ready(function(){
  $('#root-path-avatar-link').find('span:last').replaceWith(function() {
    return $('img', this);
  });

  $('.sidebar').hover(function(){
    if($('.sidebar').width() === 60){
      collapsedSidebar();
      $(".sidebar").one('mouseleave',function(){
        collapsedSidebar();
      });
    }
  })
})

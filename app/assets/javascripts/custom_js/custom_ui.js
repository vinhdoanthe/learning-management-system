$(document).ready(function(){
  $('#root-path-avatar-link').find('span:last').replaceWith(function() {
    return $('img', this);
  });

  $('.sidebar').hover(function(){
    if($('.sidebar').width() === 60){
      collapsedSidebar();
      $("#public_profile").show();
      $(".sidebar").one('mouseleave',function(){
        $('#public_profile').hide();
        collapsedSidebar();
      });
    }
  })

  $('.sidebar').ready(function(){
    if($('.sidebar').width() === 60){
      $("#public_profile").hide();
    }else{
      $("#public_profile").show();
    }
  });

  $('.menutoggle').click(function(){
    if($('.sidebar').width() === 60){
      $("#public_profile").hide();
    }else{
      $("#public_profile").show();
    }
  })
})

$(document).ready(function(){
  $('#root-path-avatar-link').find('span:last').replaceWith(function() {
    return $('img', this);
  });

  $('.sidebar').hover(function(){
    if($('.sidebar').width() === 60){
      collapsedSidebar();
      $('.sidebar-inner ul li a span').show();
      $("#public_profile").show();
      $(".sidebar").one('mouseleave',function(){
        $('#public_profile').hide();
        collapsedSidebar();
        $('.sidebar-inner ul li a span').hide();
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
      $('.sidebar-inner ul li a span').hide();
    }else{
      $("#public_profile").show();
      $('.sidebar-inner ul li a span').show();
    }
  })
})

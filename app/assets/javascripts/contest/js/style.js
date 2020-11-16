//var function header scroll
$(function () {
  $(document).ready(function(){
    if($('.l-nav.is-transparent').length > 0){
      var nav = $('.l-nav.is-transparent');
      var body = $('body');
      var navHeight = nav.height();
      if(nav.length > 0){
        $(window).scroll(function(){
          if($(this).scrollTop() > navHeight - 80){
            nav.addClass('has-fixed');
            body.addClass('has-padding');
          }
          if($(this).scrollTop() <= navHeight - 80){
            nav.removeClass('has-fixed');
            body.removeClass('has-padding');
          }
        });
      }
    }
  });
});

//var function mail slider
$(function () {
  $(document).ready(function(){
    if($('.js-slider').length > 0){
      var mainSlider = $('.js-slider');
      mainSlider.owlCarousel({
        loop:true,
        margin:0,
        items:1,
        responsiveClass:false,
        nav:false,
        dots:false,
        autoplay:true,
        autoHeight:false,
        autoplayTimeout:6000,
        autoplaySpeed:2000,
        autoplayHoverPause:false,
        navText:false,
        thumbs: true,
        thumbsPrerendered: true,
      });
      mainSlider.on('changed.owl.carousel', function(event) {
        var item = event.item.index - 2;     // Position of the current item
        $('.c-slider-item__title').removeClass('animate__animated animate__zoomInDown animated-2s delayp2');
        $('.owl-item').not('.cloned').eq(item).find('.c-slider-item__title').addClass('animate__animated animate__zoomInDown animated-2s delayp2');
        $('.c-slider-item__more').removeClass('animate__animated animate__zoomInUp animated-2s delayp4');
        $('.owl-item').not('.cloned').eq(item).find('.c-slider-item__more').addClass('animate__animated animate__zoomInUp animated-2s delayp4');
        $('.c-slider-item__img').removeClass('animate__animated animate__slideInUp animated-2s delayp6');
        $('.owl-item').not('.cloned').eq(item).find('.c-slider-item__img').addClass('animate__animated animate__slideInUp animated-2s delayp6');
      });
    }
  });
});

//var function js scroll click
$(function () {
  $(document).ready(function(){
    if($('.js-scroll').length > 0){
      $('.js-scroll a').click(function(e){
        var id = $(this).attr("href");
        e.preventDefault();
        $("html, body").animate({scrollTop: $(id).offset().top - 80}, 700);
      });
    }
  });
});

//var function template slider 5
$(function () {
  $(document).ready(function(){
    if($('.js-slider-5').length > 0){
      $('.js-slider-5').owlCarousel({
        loop:false,
        margin:0,
        responsiveClass:false,
        nav:true,
        dots:false,
        autoplay:false,
        autoHeight:false,
        autoplayTimeout:6000,
        autoplaySpeed:1000,
        autoplayHoverPause:true,
        navText:false,
        thumbs: true,
        thumbsPrerendered: true,
        responsive:{
          0:{
            items:1
          },
          768:{
            items:3
          },
          1200:{
            items:4
          },
          1600:{
            items:5
          }
        }
      });
    }
  });
});

//var function template slider 2
$(function () {
  $(document).ready(function(){
    if($('.js-slider-2').length > 0){
      $('.js-slider-2').owlCarousel({
        loop: $('.js-slider-2 .c-winner-item').size() > 1 ? true:false,
        margin:0,
        responsiveClass:false,
        nav:true,
        dots:false,
        autoplay:false,
        autoHeight:false,
        autoplayTimeout:6000,
        autoplaySpeed:1000,
        autoplayHoverPause:true,
        navText:false,
        responsive:{
          0:{
            items:1,
            margin:0
          },
          768:{
            items:2,
            margin:10
          },
          992:{
            items:2,
            margin:20
          },
          1200:{
            items:2,
            margin:30
          }
        }
      });
    }
  });
});

//var function theme slider
$(function () {
  $(document).ready(function(){
    if( $('.c-road-slider').length > 0 && $('.c-calender-slider').length > 0 ){
      var calendarOwl = $('#calendar-slider-id');
      var calendarOwlOption = {
        loop:false,
        margin:0,
        responsiveClass:false,
        nav:false,
        dots:false,
        autoplay:false,
        autoHeight:false,
        autoplayTimeout:6000,
        autoplaySpeed:1000,
        autoplayHoverPause:true,
        navText:false,
        center:true,
        responsive:{
          0:{
            items:1,
            margin:0
          },
          768:{
            items:3,
            margin:10
          }
        }
      };
      var roadOwl = $('#road-slider-id');
      roadOwl.owlCarousel({
        loop:false,
        margin:0,
        items:1,
        responsiveClass:false,
        nav:true,
        dots:false,
        autoplay:false,
        autoHeight:false,
        autoplayTimeout:6000,
        autoplaySpeed:1000,
        autoplayHoverPause:true,
        navText:false
      });
      calendarOwl.owlCarousel(calendarOwlOption);
      calendarOwl.on("dragged.owl.carousel", function (event) {
        if (event.relatedTarget['_drag']['direction'] === "left") {
          roadOwl.trigger('next.owl.carousel');
        } else {
          roadOwl.trigger('prev.owl.carousel');
        }
      });
      roadOwl.on("dragged.owl.carousel", function (event) {
        if (event.relatedTarget['_drag']['direction'] === "left") {
          calendarOwl.trigger('next.owl.carousel');
        } else {
          calendarOwl.trigger('prev.owl.carousel');
        }
      });
      $('.c-calendar-item').click(function (e) {
        e.preventDefault();
        var startNumber = $(this).attr('data-number');
        roadOwl.trigger('to.owl.carousel', startNumber-1);
        calendarOwl.trigger('to.owl.carousel', startNumber-1);
      });
      $('.c-road-slider .owl-carousel .owl-nav .owl-prev').click(function() {
        calendarOwl.trigger('prev.owl.carousel');
      });
      $('.c-road-slider .owl-carousel .owl-nav .owl-next').click(function() {
        calendarOwl.trigger('next.owl.carousel');
      });
    }
  });
});

//var function award slider
$(function () {
  $(document).ready(function(){
    if($('.js-award-slider').length > 0){
      var mainSlider = $('.js-award-slider');
      mainSlider.owlCarousel({
        loop:true,
        margin:0,
        items:1,
        responsiveClass:false,
        nav:true,
        dots:false,
        autoplay:true,
        autoHeight:false,
        autoplayTimeout:8000,
        autoplaySpeed:2000,
        autoplayHoverPause:false,
        navText:false,
      });
    }
  });
});

//var function view more product detail
$(function () {
  $(document).ready(function(){
    if($('.c-product-content').length > 0){
      $('.c-product-content__btn .btn').click(function (e) {
        e.preventDefault();
        var parent = $(this).parent().parent();
        parent.addClass('active');
      });
    }
  });
});

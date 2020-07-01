$('#swiper-video-list').ready(function() {

  var swiper = new Swiper('.swiper-container', {
    slidesPerView: 5,
    spaceBetween: 5,
    pagination: {
      el: '.swiper-pagination',
      clickable: true,
    },
  });

  console.log(swiper)
})

function filter_redeem_product(){
  $.ajax({
    method: "GET",
    url: "redeem/redeem_transactions/company_product",
    dataType: 'script'
  })
}

var galleryThumbs = new Swiper('.gallery-thumbs', {
  spaceBetween: 10,
  slidesPerView: 4,
  loop: true,
  freeMode: true,
  loopedSlides: 5, //looped slides should be the same
  watchSlidesVisibility: true,
  watchSlidesProgress: true,
});
var galleryTop = new Swiper('.gallery-top', {
  spaceBetween: 10,
  loop:true,
  loopedSlides: 5, //looped slides should be the same
  navigation: {
    nextEl: '.swiper-button-next',
    prevEl: '.swiper-button-prev',
  },
  thumbs: {
    swiper: galleryThumbs,
  },
});

$(document).ready(function(){
  $(function() {
      $('input[name="expected_time"]').daterangepicker({
        singleDatePicker: true,
        showDropdowns: true,
        minYear: 2020,
        maxYear: 2030,
      })
    });

  $('#redeem_product_confirm').on('click', function(){
    product_id = $('input[name="redeem_product_id"]').val();
    color = $('input[name="product_color"]:checked').val();
    amount = $('.product_amount').val();
    size = $('.product_size').val();
   company = $('#select_redeem_company').val();
    time = $('#redeem_time').val();
    $.ajax({
      method: 'POST',
      url: '/redeem/redeem_transactions/create_transaction',
      data: {product_id: product_id, product_color: color, product_size: size, product_company: company, product_time: time, product_amount: amount },
      success: function(res){
        display_noti(res)
      }
    })
  })
})

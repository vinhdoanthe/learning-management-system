//=require swiper.min.js
function filter_redeem_product(){
  $.ajax({
    method: "GET",
    url: "redeem/redeem_transactions/company_product",
    dataType: 'script'
  })
}


$(document).ready(function(){
  $(function() {
      $('input[name="expected_time"]').daterangepicker({
        singleDatePicker: true,
        showDropdowns: true,
        minYear: 2020,
        maxYear: 2030,
      })
    });


  $('#btn_redeem_product_confirm').on('click', function(){
    color = $(this).closest('.product_infomation').find('input[name="product_color"]:checked').val()
    amount = $(this).closest('.product_infomation').find('select.product_amount').val();
    size = $(this).closest('.product_infomation').find('select.product_size').val();
    product_id = $(this).data('product');
    $('#active_product_size').val(size);
    $('#active_product_color').val(color);
    $('#active_product_amount').val(amount);

    $.ajax({
      url: '/redeem/redeem_products/product_detail?product_id=' + product_id,
      method: 'GET',
      dataType: 'script'
    })
  });
})

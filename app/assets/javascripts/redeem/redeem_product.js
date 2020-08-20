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


  $('.redeem_product_submit').on('click', function(e){
    color = $(this).closest('.product_infomation').find('input.product_color:checked').val()
    amount = $(this).closest('.product_infomation').find('input[name="product_amount"]').val();
    if (parseInt(amount) === 0){
      alert('Chọn sai số lượng sản phẩm! Vui lòng chọn lại');
      e.stopPropagation();
      return;
    }
    size = $(this).closest('.product_infomation').find('select.product_size').val();
    product_id = $(this).data('product');
    $('#active_product_size').val(size);
    $('#active_product_color').val(color);
    $('#active_product_amount').val(amount);

    $.ajax({
      url: '/redeem/redeem_products/product_detail?product_id=' + product_id + "&size=" + size + "&color=" + color,
      method: 'GET',
      dataType: 'script'
    })
  });
})

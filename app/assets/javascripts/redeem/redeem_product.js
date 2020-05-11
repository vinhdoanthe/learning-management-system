function filter_redeem_product(){
  $.ajax({
    method: "GET",
    url: "redeem/redeem_transactions/company_product",
    dataType: 'script'
  })
}

$(document).ready(function(){
  var product_id = '';
  var color = '';
  var size = '';
  var amount = '';
  var company = '';
  var time = '';

  $('.redeem_product_submit').on('click', function(){
    product_id = $(this).parent().find($('input[name="redeem_product_id"]')).val()
    color = $(this).parent().closest('.product_infomation').find($('input[name="product_color"]')).val()
    amount = $(this).parent().closest('.rt-detail').find($('select.product_amount')).val()
    size = $(this).parent().closest('.rt-detail').find($('select.product_size')).val()
  })
  
  $('#redeem_product_confirm').on('click', function(){
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

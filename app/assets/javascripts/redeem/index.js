function changeQuantity(target, count){
  current_val = target.val()
  new_val = parseInt(current_val) + count
  if (new_val >= 0){
    target.val(new_val);
  }else{
    target.val(0);
  }
}

let getRedeemHistory = (user_id) => {
  $.ajax({
    method: 'GET',
    url: '/redeem/redeem_transactions/redeem_history',
    data: { user_id: user_id },
    dataType: 'script'
  })
}

$(document).ready(function() {
  $('.product_categories').on('change', function(){
    $('.product_item').hide();
    category_id = $(this).val();
    if (category_id == '-1'){
      $('.product_item').show()
    }
    else{
      $('.product_category_' + category_id).show();
    }
  });

  $('.minus_quantity').on('click', function(){
    target = $(this).parent().find('input[name="product_amount"]');
    changeQuantity(target, -1)
  })
  $('.plus_quantity').on('click', function(){
    target = $(this).parent().find('input[name="product_amount"]');
    changeQuantity(target, 1)
  })

  $('#show_modal_redeem_history').click(function(){
    user_id = $(this).data('student')
    getRedeemHistory(user_id)
  })
});

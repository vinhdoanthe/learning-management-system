$(document).ready(function(){
  $('#submit-create-contest-exchange').click(function(){
    from = $('#exchange_from').val();
    end = $('#exchange_end').val();
    title = $('#exchange_title').val();
    point = $('#exchange_point').val();
    status = $('#exchange_status:checked').length;
    data = { top_from: from, top_end: end, title: title, point: point, status: status }
    $.ajax({
      url: '/adm/contest/contest_exchanges/create_new',
      method: "POST",
      data: data,
      success: function(res){
        display_response_noti(res)
        exchange = res.exchange
        $('#body-exchange').append(`
          <tr>
          <th>${ exchange.id }</th>
          <th>${ exchange.title }</th>
          <th>${ exchange.top_from }</th>
          <th>${ exchange.top_end }</th>
          <th>${ exchange.point }</th>
          <th>
          ${ (exchange.status === 'active') ?
            `<input type="checkbox" class="form-check-input exchange_status" data-exchange="${ exchange.id }" checked>`
            :
            `<input type="checkbox" class="form-check-input exchange_status" data-exchange="${ exchange.id }">`
          }
          </th>
          <th></th>
          </tr>
          `);
      }
    })
  })

  $('#body-exchange').on('change', '.exchange_status',function(){
    id = $(this).data('exchange');
    status = $(this).is(':checked');
    $.ajax({
      method: 'POST',
      url: '/adm/contest/contest_exchanges/update',
      data: { status: status, id: id },
      success: function(res) {
        display_response_noti(res)
      }
    })
  })

  //$('#body-exchange').on('click', '.delete-exchange', function(){
  //  id = $(this).data('exchange');
  //  if ( confirm('Ban chac chan muon xoa?')){
  //  $.ajax({
  //    method: 'POST',
  //    url: '/adm/contest/contest_exchanges/delete',
  //    data: { id: id },
  //    success: function(res) {
  //      display_response_noti(res)
  //    }
  //  })
  //  }
  //})

})

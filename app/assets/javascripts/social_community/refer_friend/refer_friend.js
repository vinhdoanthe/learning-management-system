$('.delete_refer_request').on('click', function(){
  key = $(this).data('refer')
  note = ''
  $.ajax({
    method: 'POST',
    url: '/social_community/refer_friends/cancel',
    dataType: 'script',
    data: {refer_key: key, note: note, authenticity_token: $('[name="csrf-token"]')[0].content}
  })
})

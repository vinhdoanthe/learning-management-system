function readURL(input, target) {
  if (input.files) {
    $.each(input.files, function (i, photo) {
      var reader = new FileReader();
      reader.onload = function (e) {
        $(target).append('<img class="photo_review" src="' + e.target.result + '" alt="" />');
      }

      reader.readAsDataURL(photo);    
    })
  } 
}


$(document).ready(function(){
    $('#modal_contest_event_detail').on('change', '#event-thumbnail', function(){
      $('#event_thumbnail_preview').html('');
      readURL(this, '#event_thumbnail_preview')
    })

  $('.delete_contest_event').on('click', function(){
    id = $(this).data('contest-event');
    $.ajax({
      method: 'post',
      url: '/adm/contest/contest_events/delete_event',
      data: { id: id },
      success: function(res){
        display_response_noti(res);
        if (res.type === 'success'){
          location.reload()
        }
      }
    })
  
  })

  $('#modal_contest_event_detail').on('click', '#update_contest_event_confirm', function(){
    var data = new FormData();
    id = $('input[name="event-id"]').val();
    name = $('#event_name').val();
    link = $('#event_link').val();
    thumbnail = ''
    
    data.append('id', id);
    data.append('link', link);
    data.append('name', name);
    if ($('#event-thumbnail')[0].files.length > 0) {
      thumbnail = $('#event-thumbnail')[0].files[0];
    }
    data.append('thumbnail', thumbnail);

    $.ajax({
      method: 'POST',
      url: '/adm/contest/contest_events/update_event',
      data: data,
      contentType: false,
      processData: false,
      success: function(res){
        $('#modal_contest_event_detail').modal('hide');
        display_response_noti(res);
        if (res.type === 'success'){
          location.reload();
        }
      }
    })
  })

  $('.contest-event-detail').on('click', function(){
    id = $(this).data('contest-event')
    $.ajax({
      method: 'GET',
      url: `/adm/contest/contest_events/event_detail?id=${ id }`,
      dataType: 'script'
    })
  })
})

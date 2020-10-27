$(document).ready(function(){
  setSummerNote('#criterion_desciption');

  $("#create_criterion_confirm").on('click', function(){
    name = $('#criterion_name').val();
    description = $('#criterion_description').val();
    point = $('#criterion_point').val();
    data = { name: name, description: description, point: point }

    $.ajax({
      method: "POST",
      url: "/adm/contest/contest_criterions/create_criterion",
      data: data,
      dataType: 'script'
    })
  })

  $('.delete-criterion').on('click', function(){
    id = $(this).data('criterion');
    topic_id = $('input[name="topic_id"]').val()

    $.ajax({
      method: "POST",
      url: "/adm/contest/contest_criterions/delete_criterion",
      data: { id: id, topic_id: topic_id },
      success: function(res){
        display_response_noti(res)
      }
    })
  })
})

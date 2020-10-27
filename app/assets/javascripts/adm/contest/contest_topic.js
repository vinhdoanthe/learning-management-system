$(document).ready(function(){
  setSummerNote('.contest-topic-description-textarea')
  setSummerNote('.contest-topic-rule-textarea')

  $('#topic-start-date').daterangepicker({
    singleDatePicker: true,
    showDropdowns: true,
    locale: {
      format: 'DD/MM/YYYY'
    }
  })

  $('#topic-end-date').daterangepicker({
    singleDatePicker: true,
    showDropdowns: true,
    locale: {
      format: 'DD/MM/YYYY'
    }
  })

  $('#create-contest-topic-confirm').click(function(){
    var data = new FormData();
    topic_id = $(this).data('topic')
    data.append('topic_id', name);
    name = $('#topic_name').val();
    data.append('name', name);
    contest_id = $('input[name="contest-id"]').val();
    data.append('contest_id', contest_id);
    region = $('#topic_region').val();
    data.append('region', region);
    description = $('.contest-topic-description-textarea').val();
    data.append('description', description);
    rule = $('.contest-topic-rule-textarea').val();
    data.append('rule', rule);

    contest_prizes = new Array();
    $('.choose_prizes:checked').each(function(){
      contest_prizes.push($(this).val());
    })

    contest_criterions = new Array();
    $('.choose_criterions:checked').each(function(){
      contest_criterions.push($(this).val());
    })

    data.append('contest_prizes[]', contest_prizes);
    data.append('contest_criterions[]', contest_criterions);
    start_time = $('#topic-start-date').val()
    end_time = $('#topic-end-date').val()
    data.append("start_time", start_time);
    data.append("end_time", end_time);

    file = $('#topic_thumbnail')[0].files[0]
    file_type = file.name.split('.').pop().toLowerCase();
    if($.inArray(file_type, ['png','jpg','jpeg', 'heic']) == -1) {
      arlert("Chi chap nhan anh duoi 'png','jpg', 'jpec', 'heic'!");
      return
    }else{
      data.append("thumbnail", file);
    }

    $.ajax({
      method: 'POST',
      url: '/adm/contest/contest_topics/create_topic',
      data: data,
      processData: false,
      contentType: false,
      dataType: 'script'
    })
  })

  bsCustomFileInput.init();
})

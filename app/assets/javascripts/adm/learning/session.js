function getDataSession(data){
  $.ajax({
    url: '/adm/learning/sessions/filter_sessions',
    method: 'POST',
    data: data,
    dataType: 'script'
  })
}

function getDataFilter(){
  batch_id = $('#filter-batch').val();
  company = $('#filter-company').val();
  state = $('#filter-state').val();
  start_time = $('#filter-time').data('daterangepicker').startDate._d;
  end_time = $('#filter-time').data('daterangepicker').endDate._d;
  photo_state = $('input[name="session_photo"]:checked').val();

  return { batch_id: batch_id, company: company, state: state, start_time: start_time, end_time: end_time, photo_state: photo_state }
}

function getSessionPhotos(session_id) {
  $.ajax({
    url: '/adm/learning/sessions/session_photos?session_id=' + session_id,
    method: 'GET',
    dataType: 'script'
  })
}

$(document).ready(function(){
  var data = getDataFilter();
  data['page'] = 0
  data['index'] = 1
  getDataSession(data);

  
  $('#paginator').on('click', '.previous_page', function () {
    data = getDataFilter();
    data['page'] = $(this).data('page')
    data['index'] = -1;
    getDataSession(data)
  })

  $('#paginator').on('click', '.next_page', function () {
    data = getDataFilter();
    data['page'] = $(this).data('page')
    data['index'] = 1;
    getDataSession(data)
  })

  $('#submit_filter_sessions').on('click', function(){
    data = getDataFilter();
    data['page'] = 0;
    data['index'] = 1;
    getDataSession(data);
  })

  $('#session_data_table').on('click', '.session_photo_modal', function(){
    session_id = $(this).data('session')
    getSessionPhotos(session_id)
  })
})

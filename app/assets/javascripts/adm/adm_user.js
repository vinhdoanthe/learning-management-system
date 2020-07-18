function get_data_index(data) {
  $.ajax({
    url: "/adm/user/filter_users",
    method: "POST",
    data: data,
    dataType: 'script'
  })
}

function get_filter_params() {
  var company = $("#filter-company").val();
  var role = $("#filter-role").val();
  var search = $("#search-user").val();
  var had_login = ''
  var is_active = ''

  if ($('#user-has-sign-in').is(':checked')) {
    had_login = 1
  } else {
    had_login = 0
  }

  if ($('#user-is-active').is(':checked')) {
    is_active = true
  } else {
    is_active = false
  }

  data = { company: company, role: role, search: search, had_login: had_login, is_active: is_active }

  return data
}

$(document).ready(function () {
  $("#filter-company").select2({
  });
  $("#filter-role").select2({
  });

  data = get_filter_params()
  data['page'] = 0
  data['index'] = 1
  get_data_index(data);

  $('#paginator').on('click', '.previous_page', function () {
    data = get_filter_params();
    data['page'] = $(this).data('page')
    data['index'] = -1;
    get_data_index(data)
  })

  $('#paginator').on('click', '.next_page', function () {
    data = get_filter_params();
    data['page'] = $(this).data('page')
    data['index'] = 1;
    get_data_index(data)
  })

  $('#submit_filter_user').on('click', function () {
    data = get_filter_params();
    data['page'] = 0;
    data['index'] = 1;
    get_data_index(data)
  })
})

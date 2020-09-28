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
  var had_login = $('#user-has-sign-in').val();
  var is_active = $('#user-is-active').val();

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
    $('#loading-content-div').show();
    $('#user_data_table').hide();
    $('#paginator').hide();
    data = get_filter_params();
    data['page'] = 0;
    data['index'] = 1;
    get_data_index(data)
  })


  $('#adm_create_user').on('click', function(){
    username = $('input[name="username"]').val();
    email = $('input[name="email"]').val();
    password = $('input[name="password"]').val();
    confirmation_password = $('input[name="confirm_password"]').val();
    role = $('select[name="user_role"]').val();
    company = $('select[name="user_company"]').val();

    $.ajax({
      method: 'POST',
      url: '/adm/user/create_user',
      data: { username: username,email: email, password: password, confirmation_password: confirmation_password, account_role: role, company: company, authenticity_token: $('[name="csrf-token"]')[0].content},
      success: function(res){
        $('#adm_create_user').attr("disabled", true)
        display_response_noti(res)
      }
    })
  })
})

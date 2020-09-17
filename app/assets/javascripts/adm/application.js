function display_noti(error) {
  html = '<div class="alert alert-' + error.type + '"><a href="#" class="close" data-dismiss="alert">×</a><div id="flash_' + error.type + '">' + error.message + '</div></div>'
  $('#noti-message').html(html);
  setTimeout(function () {
    $('#noti-message').html('');
  }, 3000);
}

function display_response_noti(res) {
  if (res.type === 'danger'){
    toastr.error(res.message)
  }else if (res.type === 'success'){
    toastr.success(res.message)
  }else if (res.type === 'warning'){
    toastr.warning(res.message)
  }
}

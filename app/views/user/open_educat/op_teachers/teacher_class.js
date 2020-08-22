var fillClassTable = (data) => {
  $.ajax({
    method: 'POST',
    url: '/user/open_educat/teacher_class_content',
    data: data,
    dataType: 'script'
  })
}

$(document).ready(function(){
  fillClassTable();
})

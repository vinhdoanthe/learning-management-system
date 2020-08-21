var teacherBatchStart;
var teacherBatchEnd;

var fillClassTable = (render) => {
  data = { start_time: teacherBatchStart, end_time: teacherBatchEnd };
  data.active = $('#filter_type').val();
  data.render = render;
  data.company = $('#filter_company').val();

  $.ajax({
    method: 'POST',
    url: '/user/open_educat/teacher_class_content',
    data: data,
    dataType: 'script'
  })
}

$(document).ready(function(){
  fillClassTable(1);

  $('#filter_teacher_class').on('change', '#filter_company', function(){
    $('#table_loading_homework').show();
    $('#table_teacher_class').hide();
    fillClassTable();
  })

  $('#filter_teacher_class').on('change', '#filter_type', function(){
    $('#table_loading_homework').show();
    $('#table_teacher_class').hide();
    fillClassTable();
  })
})

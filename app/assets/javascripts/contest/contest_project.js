function setDefaultDatePicker(target, month_value){
  var d = new Date();
  date = new Date(d.setMonth(d.getMonth() + month_value));
  $(target).datepicker('autoHide', true).datepicker('setDate', date);
}

function setTimeFormat(time, value){
  day = time.getDate();
  month = time.getMonth() + value;
  year = time.getFullYear();

  return `${ day }/${ month }/${ year }`
}

function getProjectsContent(option){
  $('.contest-projects-content').html(`<div class="c-loading"> <div class="c-loading__icon"><i class="icon32-sand-clock"></i></div> <div class="c-loading__text">Đợi xíu nha...    </div> </div>`)
  company_id = $('#select_project_company').val();
  contest_id = $('input#input_contest_id').val()
  if (option === 'month'){
    time = new Date();
    start_time = setTimeFormat(time, 0);
    end_time = setTimeFormat(time, 1);
  }else{
    start = $('input.start-date').datepicker('getDate');
    start_time = setTimeFormat(start, 0);
    end = $('input.end-date').datepicker('getDate');
    end_time = setTimeFormat(start, 1);
  }

  $.ajax({
    method: "GET",
    url: `/contest/contest_projects/projects_content?contest_id=${ contest_id }`,
    data: { company_id: company_id, start_time, end_time },
    dataType: 'script'
  })
}
$(document).ready(function(){
  getProjectsContent('month');

  $('#select_project_company').change(function(){
    company_id = $(this).val();
    $('.c-project-detail').hide();
    i = 0;
    if ($(this).val() === 'all'){
      $('.c-project-detail').show();
      $('.project-count').html(total);
    }else{
      $('.c-project-detail').each(function(index, project) {
        if ($(project).data('company') === parseInt(company_id)){
          $(project).show();
          i += 1;
          $('.project-count').html(i);
        }else{
          $('.project-count').html(i);
        }
      });
    }
  })

  $('.show_topic_projects').on('click', function(){
    $('#select_project_topic').val($(this).data('topic'));
    getProjectsContent();
    alias_name = $('input#input_contest_alias').val();
    window.location.href = `/contest/${ alias_name }/contest_projects#contest-project-list`;
  })

  var $startDate = $('.start-date');
  var $endDate = $('.end-date');

  $startDate.datepicker({
    autoHide: true,
    language: 'vi-VN',
    format: 'dd-mm-yyyy',
  });
  $endDate.datepicker({
    autoHide: true,
    language: 'vi-VN',
    format: 'dd-mm-yyyy',
    startDate: $startDate.datepicker('getDate'),
  });

  $startDate.on('change', function () {
    $endDate.datepicker('setStartDate', $startDate.datepicker('getDate'));
  });
})

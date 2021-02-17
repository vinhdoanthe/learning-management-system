function setDefaultDatePicker(target, month_value){
  var d = new Date();
  date = new Date(d.setMonth(d.getMonth() + month_value));
  $(target).datepicker('autoHide', true).datepicker('setDate', date);
}

function setTimeFormat(time, value){
  day = time.getDate();
  month = time.getMonth() + value;
  year = time.getFullYear();

  if (month === 12){
    month = 0;
    year = year + 1;
  }

  return `${ day }/${ month }/${ year }`
}

function getProjectsContent(option, topic_id){
  $('.contest-projects-content').html(`<div class="c-loading"> <div class="c-loading__icon"><i class="icon32-sand-clock"></i></div> <div class="c-loading__text">Đợi xíu nha...    </div> </div>`)
  company_id = $('#select_project_company').val();
  contest_id = $('input#input_contest_id').val()
  start_time = '';
  end_time = '';

  if (option === 'month'){
    time = new Date();
    start_time = setTimeFormat(time, 0);
    end_time = setTimeFormat(time, 1);
  }else{
    start_time = $('input.start-date').datepicker('getDate', true);
    end_time = $('input.end-date').datepicker('getDate', true);
  }

  $.ajax({
    method: "GET",
    url: `/contest/contest_projects/projects_content?contest_id=${ contest_id }`,
    data: { company_id: company_id, start_time: start_time, end_time: end_time, topic_id: topic_id },
    dataType: 'script'
  })
}
$(document).ready(function(){
  getProjectsContent('month', '');

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
    topic_id = $(this).data('topic');
    getProjectsContent('', topic_id);
    alias_name = $('input#input_contest_alias').val();
    window.location.href = `/contest/${ alias_name }/contest_projects#contest-project-list`;
  })

  $('.current_month_topic_projects').on('click', function(){
    setDefaultDatePicker('.start-date', -1);
    setDefaultDatePicker('.end-date', 0);
    getProjectsContent('month', '');
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

  $('.end-date').on('pick.datepicker', function(){
    getProjectsContent('', '');
  })
})

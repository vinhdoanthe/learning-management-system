let getSocialStudentProject = (data) => {
  $.ajax({
    url: '/social_community/sc_student_projects/social_student_projects_content',
    method: 'GET',
    data: data,
    dataType: 'script'
  })
}

let getDataFilter = (page) => {
  course = $('#filter_course_projects').val();
  subject = $('#filter_subject_projects').val();
  project_show_video = 0;
  introduction_video = 0;
  presentation = 0;

  if ($('input[name="filter_project_video_show"]:checked').length > 0){
    project_show_video = 1;
  }
  if ($('input[name="filter_project_link"]:checked').length > 0){
    introduction_video = 1;
  }
  if ($('input[name="filter_project_presentation"]:checked').length > 0){
    presentation  = 1;
  }
  return { course: course, subject: subject, introduction_video: introduction_video, presentation: presentation, project_show_video: project_show_video, page: page }
}

$(document).ready(function(){
  getSocialStudentProject();
  $('#paginator').hide();
  $('.prev_page_projects').hide();
  //$('#social_student_projects_filter').on('change', '#filter_course_projects', function(){
  //  debugger
  //  $('#loading_div').show();
  //  $('#social_student_projects_content').hide();
  //  data = getDataFilter();
  //  getSocialStudentProject(data);
  //})

  //$('#social_student_projects_filter').on('change', '#filter_subject_projects', function(){
  //  $('#loading_div').show();
  //  $('#social_student_projects_content').hide();
  //  data = getDataFilter();
  //  getSocialStudentProject(data);
  //})

  $('#social_student_projects_filter').on('click', 'input[name="filter_project_video_show"]', function(){
    $('#loading_div').show();
    $('#social_student_projects_content').hide();
    if( $(this).is(':checked') ) {
      data = getDataFilter(0);
      getSocialStudentProject(data);
    }
  });

  $('#social_student_projects_filter').on('click', 'input[name="filter_project_link"]', function(){
    $('#loading_div').show();
    $('#social_student_projects_content').hide();
    if( $(this).is(':checked') ) {
      data = getDataFilter(0);
      getSocialStudentProject(data);
    }
  });
    
  $('#social_student_projects_filter').on('click', 'input[name="filter_project_presentation"]', function(){
    $('#loading_div').show();
    $('#social_student_projects_content').hide();
    if( $(this).is(':checked') ) {
      data = getDataFilter(0);
      getSocialStudentProject(data);
    }
  });

  $('#paginator').on('click', '.next_page_projects', function(){
    $('#loading_div').show();
    $('#social_student_projects_content').hide();
    page = $(this).data('page');
      data = getDataFilter(page);
      getSocialStudentProject(data);
  })
  $('#paginator').on('click', '.prev_page_projects', function(){
    $('#loading_div').show();
    $('#social_student_projects_content').hide();
    page = $(this).data('page');
      data = getDataFilter(page);
      getSocialStudentProject(data);
  })
})

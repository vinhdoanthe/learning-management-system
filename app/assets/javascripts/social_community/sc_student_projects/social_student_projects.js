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
  project_type = $('#filter_project_type').val();

  project_show_video = 0;
  introduction_video = 0;
  presentation = 0;

  if ($('input[name="filter_project_video_show"]:checked').length > 0){
    introduction_video = 1;
  }
  if ($('input[name="filter_project_link"]:checked').length > 0){
    project_show_video = 1;
  }
  if ($('input[name="filter_project_presentation"]:checked').length > 0){
    presentation  = 1;
  }
  return { course: course, subject: subject, introduction_video: introduction_video, presentation: presentation, project_show_video: project_show_video, page: page, project_type: project_type }
}

$(document).ready(function(){
  getSocialStudentProject();

  $('#social_student_projects_filter').on('click', 'input[name="filter_project_video_show"]', function(){
    $('#loading_div').show();
    $('#has_student_project').hide();
      data = getDataFilter(0);
      getSocialStudentProject(data);
  });

  $('#social_student_projects_filter').on('click', 'input[name="filter_project_link"]', function(){
    $('#loading_div').show();
    $('#has_student_project').hide();
      data = getDataFilter(0);
      getSocialStudentProject(data);
  });
    
  $('#social_student_projects_filter').on('click', 'input[name="filter_project_presentation"]', function(){
    $('#loading_div').show();
    $('#has_student_project').hide();
      data = getDataFilter(0);
      getSocialStudentProject(data);
  });

  $('#paginator').on('click', '.next_page_projects', function(){
    $('#loading_div').show();
    $('#has_student_project').hide();
    page = $(this).data('page');
      data = getDataFilter(page);
      getSocialStudentProject(data);
  })
  $('#paginator').on('click', '.prev_page_projects', function(){
    $('#loading_div').show();
    $('#has_student_project').hide();
    page = $(this).data('page');
      data = getDataFilter(page);
      getSocialStudentProject(data);
  })
})

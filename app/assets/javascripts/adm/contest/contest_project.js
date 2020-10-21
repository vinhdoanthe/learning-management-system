let getIndexContent = (contest_id) => {
  $.ajax({
    url: `/adm/contest/contest_projects/index_content?contest_id=${ contest_id }`,
    method: "GET",
    dataType: 'script'
  })
}

let showContestProject = (project_id) => {
  $.ajax({
    method: 'GET',
    url: '/social_community/student_project_detail?project_id=' + project_id,
    dataType: 'script'
  })
}

$(document).ready(function(){
  contest_id = $('input[name="contest_id"]').val();
  getIndexContent('')

  $('#adm_project_index').on('click','.contest_project_show', function(){
    project_id = $(this).data('project');
    showContestProject(project_id)
  })
})

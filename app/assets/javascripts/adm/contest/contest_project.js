let getIndexContent = () => {
  contest_id = $('#select_contest').val();
  topic_id = $('#select_topic').val();
  region = $('#select_region').val();
  data = { contest_id: contest_id, topic_id: topic_id, region: region }
  $.ajax({
    url: `/adm/contest/contest_projects/index_content`,
    method: "GET",
    data: data,
    dataType: 'script'
  })
}
let calculateWeekPrize = (topic_id, type) => {
  $.ajax({
    url: '/adm/contest/contest_projects/calculate_point',
    method: 'POST',
    data: { topic_id: topic_id, type: type },
    success: function(res){
      display_response_noti(res);
      location.reload();
    }
  })
}

let getTopicList = (contest_id) => {
  $.ajax({
    url: `/adm/contest/topic_list?id=${ contest_id }`,
    method: 'GET',
    success: function(res){
      html = '';
      $.each(res, function( index, topic ){
        html += `<option value=${ topic[0] }> ${ topic[1] } </option>`
      })

      $('#select_topic').html(html)
    }
  })
}
let showContestProject = (project_id) => {
  $.ajax({
    method: 'GET',
    url: '/contest/contest_projects/project_detail?id=' + project_id,
    dataType: 'script'
  })
}

$(document).ready(function(){
  getIndexContent();

  $('#filter-contest-project').on('click', function(){
    getIndexContent();
  })

  $('#select_contest').on('change', function(){
    contest_id = $(this).val();
    getTopicList(contest_id);

  })

  $('#adm_project_index').on('click','.contest_project_show', function(){
    project_id = $(this).data('project');
    showContestProject(project_id)
  })

  $('#adm_project_index').on('click', '#submit-marking-project', function(){
    id = $(this).data('project')
    point = $('#marking-project-point').val();

    $.ajax({
      url: '/contest/contest_projects/marking_project',
      method: 'POST',
      data: { id: id, point: point },
      success: function(res){
        display_response_noti(res)
      }
    })
  })

  $('#adm_project_index').on('click', '#calculate_week_prize', function(){
    topic_id = $('input[name="active-topic"]').val();
    type = 'w'
    calculateWeekPrize(topic_id, type);
  })
})

let getIndexContent = () => {
  contest_id = $('#select_contest').val();
  topic_id = $('#select_topic').val();
  region = $('#select_region').val();
  month_award = $('#select_month_award').val();

  data = { contest_id: contest_id, topic_id: topic_id, region: region, month_award: month_award }
  $.ajax({
    url: `/adm/contest/contest_projects/index_content`,
    method: "GET",
    data: data,
    dataType: 'script'
  })
}
let calculateWeekPrize = (topic_id, type) => {
  if (confirm('Bạn chắc chắn muốn trao giải tuần? Không thể thay đổi nếu đã trao giải!')){
    $.ajax({
      url: '/adm/contest/contest_projects/award_week_projects',
      method: 'POST',
      data: { topic_id: topic_id, type: type },
      success: function(res){
        display_response_noti(res);
        if (res.type == 'success'){
          $('#filter-contest-project').click();
        }
      }
    })
  }
}

let calculateWeekPoint = (topic_id) => {
  $.ajax({
    url: '/adm/contest/contest_projects/calculate_point',
    method: 'POST',
    data: { topic_id: topic_id},
    success: function(res){
      display_response_noti(res);
      if (res.type === 'success'){
          $('#filter-contest-project').click();
      }
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
        display_response_noti(res);
        $(`.marking-point-${ res.id }`).html(res.point);
      }
    })
  })

  $('#adm_project_index').on('click', '#calculate_week_prize', function(){
    topic_id = $('input[name="active-topic"]').val();
    type = 'w'
    calculateWeekPrize(topic_id, type);
  })

  $('#adm_project_index').on('click', '#calculate_week_point', function(){
    topic_id = $('input[name="active-topic"]').val();
    type = 'w'
    calculateWeekPoint(topic_id);
  })
})

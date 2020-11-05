const getLeaderBoard = (contest_id) => {
  $.ajax({
    method: 'GET',
    url: `/contest/contests/leader_board?contest_id=${ contest_id }`,
    dataType: 'script'
  })
}

$(document).ready(function(){
  contest_id = $('input[name="contest_id"]').val();
  getLeaderBoard(contest_id)
})

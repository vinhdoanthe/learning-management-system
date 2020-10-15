let getContestPrizeForm = (contest_id) => {
  $.ajax({
    method: "GET",
    url: `/adm/contest/contest_prizes/prepare_create?contest_id=${contest_id}`,
    dataType: "script"
  })
}

let setSummerNote = (target) => {
  $(target).summernote({
    height: 150,
    toolbar: [
      ['style', ['bold', 'italic', 'underline', 'clear']],
      ['fontsize', ['fontsize']],
      ['color', ['color']],
      ['height', ['height']]
    ]
  });
}

$(document).ready(function(){
  $('#update-contest-button').on('click', function(){

    id = $(this).data('contest');
    name = $('input[name="contest_name"]').val();
    description = $('.contest-description-textarea').val();

    if ($('#contest_state').is(":checked")){
      state = true;
    }else{
      state = false;
    }

      $.ajax({
        url: "/adm/contest/contests/update_contest",
        method: 'POST',
        data: { name: name, description: description, state: state, id: id },
        success: function(res){
          display_response_noti(res);

          if (res.type === 'success'){
            $('.create-contest-prize-li').show();
            $('#create-contest').removeClass("active show");
            $('#create-contest-tab').removeClass('active');
            $('#create-contest-prize').addClass("active show");
            $('#create-contest-prize-tab').addClass('active');

            getContestPrizeForm(res.contest_id);
          }
        }
      })
  }) 

  $('#').on('click', '#contest_prize_type'), function(){
    if ($(this).val() == 'm'){
      $('.contest_month_award').show();
    }else{
      $('.contest_month_award').hide();
    }
  })
})


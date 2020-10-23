let getContestPrizeForm = (contest_id) => {
  $.ajax({
    method: "GET",
    url: `/adm/contest/contest_prizes/prepare_create?contest_id=${contest_id}`,
    dataType: "script"
  })
}

$(document).ready(function() {

  $('#idForm').validate({
    lang: 'vi',
    rules: {
      "contest_name": {
        required: true
      }      
    },
    messages: {
    },
    errorElement: 'span',
    errorPlacement: function (error, element) {
      error.addClass('invalid-feedback');
      element.closest('.form-group div').append(error);
    },
    highlight: function (element, errorClass, validClass) {
      $(element).addClass('is-invalid');
    },
    unhighlight: function (element, errorClass, validClass) {
      $(element).removeClass('is-invalid');
    }
  });
  
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

  $('#create-new-contest-prize').on('click', '#contest_prize_type', function(){
    if ($(this).val() == 'm'){
      $('.contest_month_award').show();
    }else{
      $('.contest_month_award').hide();
    }
  })
})


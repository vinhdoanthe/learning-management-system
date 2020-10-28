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

  $('#update-contest-button').on('click', function() {
      
      if(!$("#idForm").valid()) {
        return false;
      }

      id = $(this).data('contest');

      name = $("#contest_name").val();      
      description = $('#contest_description').val();
      rule_atendance_information = $('#rule_atendance_information').val();      
      rule_product_description = $('#rule_product_description').val();      
      rule_submission_entries = $('#rule_submission_entries').val();

      if ($('#contest_state').is(":checked")){
        state = true;
      } else {
        state = false;
      }

      $.ajax({
        url: "/adm/contest/contests/update_contest",
        method: 'POST',
        data: { name: name, description: description, rule_atendance_information: rule_atendance_information, rule_product_description: rule_product_description, rule_submission_entries: rule_submission_entries, state: state, id: id },
        success: function(res){
          display_response_noti(res);
          if (res.type === 'success') {
            $('.create-contest-prize-li').show();
            $('#create-contest').removeClass("active show");
            $('#create-contest-tab').removeClass('active');
            $('#create-contest-prize').addClass("active show");
            $('#create-contest-prize-tab').addClass('active');

            getContestPrizeForm(res.contest_id);
          }
        }
      });
  });


  $('#create-new-contest-prize').on('click', '#contest_prize_type', function(){
    if ($(this).val() == 'm'){
      $('.contest_month_award').show();
    }else{
      $('.contest_month_award').hide();
    }
  });
  
});

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
      alias_name = $("#contest_alias_name").val();      
      description = tinymce.get("contest_description").getContent();
      rule_atendance_information = $('#rule_atendance_information').val();      
      rule_product_description = $('#rule_product_description').val();      
      rule_submission_entries = $('#rule_submission_entries').val();

      if ($('#contest_state').is(":checked")){
        state = true;
      } else {
        state = false;
      }


      if ($('#contest_state').is(":checked")){
        is_publish = true;
      } else {
        is_publish = false;
      }

      if ($('#contest_state').is(":checked")){
        is_default = true;
      } else {
        is_default = false;
      }

      $.ajax({
        url: "/adm/contest/contests/update_contest",
        method: 'POST',
        data: { name: name, description: description, rule_atendance_information: rule_atendance_information, rule_product_description: rule_product_description, rule_submission_entries: rule_submission_entries, state: state, id: id, default: is_default, alias_name: alias_name },
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

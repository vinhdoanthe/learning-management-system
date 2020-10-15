var setTotalPrice = () => {
  student_price = $('#contest_student_price').val();
  teacher_price = $('#contest_teacher_price').val();
  $('#contest_price_total').val(parseInt(student_price) + parseInt(teacher_price));
}

let showMonthPrize = (contest_id) => {
  $.ajax({
    method: "GET",
    url: "/adm/contest/contest_prizes/get_available_month",
    data: { contest_id: contest_id },
    dataType: "script"
  })
}

$(document).ready(function(){
  $('.contest-prize-description-textarea').summernote({
    height: 150,
    toolbar: [
      ['style', ['bold', 'italic', 'underline', 'clear']],
      ['fontsize', ['fontsize']],
      ['color', ['color']],
      ['height', ['height']]
    ]
  });

  $('#contest_student_price').on('change', function(){
    setTotalPrice();
  });

  $('#contest_teacher_price').on('change', function(){
    setTotalPrice();
  });

  if ($('#contest_prize_type').val() === 'm'){
    $('.contest_price_month').show();
  }

  $('#submit-create-new-prize').on('click', function(){
    $(this).attr('disabled', 'disabled');
    name = $('#contest_prize_name').val();
    contest_id = $('#prize_contest_id').val();
    student_price = $('#contest_student_price').val();
    teacher_price = $('#contest_teacher_price').val();
    type = $('#contest_prize_type').val();
    prize = $('#contest_prize_order').val();
    number_awards = $('#contest_prize_number_award').val();
    description = $('.contest-prize-description-textarea').val();
    month_active = $('input[name="contest_prize_month[]"]:checked').map(function(){return $(this).val();}).get();

    data = { name: name, student_price: student_price, teacher_price: teacher_price, prize_type: type, prize: prize, number_awards: number_awards, description: description, month_active: month_active, contest_id: contest_id }

    $.ajax({
      url: "/adm/contest/contest_prizes/create_prize",
      method: "POST",
      data: data,
      dataType: 'script',
      success: function(res){
      }
    })
  })
})

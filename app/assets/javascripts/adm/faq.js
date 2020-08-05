function updateFaqQuesiton(question_content, question_state, answer_content){
  $.ajax({
    url: '/adm/faqs/update_question',
    method: 'POST',
    data: { quesiton_content: question_content, question_state: question_state, answer_content: answer_content },
    success: function(res){
      display_noti(res)
    }
  })
}

$(document).ready(function(){
  $('#update_faq_question').on('click', function(){
    tinyMCE.triggerSave();
    question_id = $('input[name="active_question"]').val();
    answer_id = $('input[name="active_answer"]').val();
    question_content = $('#question_content').val();
    answer_content = $('#answer_content').val();
    question_state = $('#question_state').val();
    updateFaqQuesiton(question_content, question_state, answer_content);
  })

})

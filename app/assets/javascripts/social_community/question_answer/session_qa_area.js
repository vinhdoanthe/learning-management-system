function get_qa_threads(params) {
  $.ajax({
    method: 'GET',
    data: params,
    url: '/social_community/question_answer/threads',
    dataType: 'script',
  })
}

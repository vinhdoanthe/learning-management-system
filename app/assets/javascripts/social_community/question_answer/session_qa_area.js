function get_qa_threads(params) {
  console.log('Called')
  $.ajax({
    method: 'GET',
    data: params,
    url: '/social_community/question_answer/threads',
    dataType: 'script',
  })
}

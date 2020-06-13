// Load all messages of a thread

function load_thread_messages(data) {
  $.ajax({
    method: 'GET',
    data: data,
    url: '/social_community/question_answer/messages',
    dataType: 'script'
  })
}

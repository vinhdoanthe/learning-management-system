function get_student_product(data){
  $.ajax({
    method: 'GET',
    url: '/user/student_product',
    data: data,
    dataType: 'script'
  })
}

$(document).ready(function(){
    $('#homework_course_selection').on('change', function(){
      course = $('#homework_course_selection').val()
      get_student_product({course: course})
    })

    $('#homework_batch_selection').on('change', function(){
      course = $('#homework_course_selection').val()
      batch = $('#homework_batch_selection').val() 
      get_student_product({course: course, batch: batch})
    })

    $('#homework_subject_selection').on('change', function(){
      course = $('#homework_course_selection').val()
      batch = $('#homework_batch_selection').val() 
      subject = $('#homework_subject_selection').val()
      get_student_product({course: course, batch: batch, subject: subject})
    })
  get_student_product();
})

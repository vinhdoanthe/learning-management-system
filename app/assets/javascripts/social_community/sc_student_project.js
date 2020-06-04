$(document).ready(function(){
	function get_student_projects(batch_id){
		$.ajax({
			method: 'GET',
			url: '/social_community/student_projects?batch_id=' + batch_id,
			dataType: 'script'
		})
	}

  $('#student_projects_li').on('click', function(){
    batch_id = $(this).data('batch-id')
    get_student_projects(batch_id)
  })
})

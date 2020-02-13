$(document).ready(function(){
	// Filter class
	function call_api(data){
	    $.ajax({
	        type: "POST",
	        url: "/user/teacher_class",
	        data: data,
	        success: function (response){
	          $.each(response.data, function(i, batch){
	            if (batch.active == true){
	                $('#batch_list').append("<tr class='batch_info'><td>"+ batch.code +"</td><td>" + batch.name +" </td><td>4</td><td>" +batch.start_date + " - " + batch.end_date + "</td><td>4/12 - Học phần 1</td><td align='right'><span class='label-edit label label-primary'>Đang diễn ra</span></td></tr>")
	            }
	            else {
	                $('#batch_list').append("<tr class='batch_info'><td>"+ batch.code +"</td><td>" + batch.name +" </td><td>4</td><td>" +batch.start_date + " - " + batch.end_date + "</td><td>4/12 - Học phần 1</td><td align='right'><span class='label-edit label label-stop'>Đã hoàn thành</span></td></tr>")
	            }
	          })
	        },

	    })
	}
	var active = $('#filter_type').val();
	var company = $('#filter_company').val();

	$('#filter_type').on('change', function(){
		active = $('#filter_type').val();
		$('.batch_info').remove();
		data = {
			'active': active,
			'company': company
		}
		call_api(data)
	});
	$('#filter_company').on('change', function(){
		company = $('#filter_company').val();
		$('.batch_info').remove();
		data = {
			'active': active,
			'company': company
		}
		call_api(data)
	});

	// Teaching schedule
	$('.teaching_schedule').click(function(e){
		e.preventDefault();
		$(this).parent().find($('.schedule_detail')).css('display','block')
	})

	$(document).mouseup(function(e) {
	    var container = $(".schedule_detail");
	    if (!container.is(e.target) && container.has(e.target).length === 0) 
	    {
	        container.hide();
	    }
	});
})


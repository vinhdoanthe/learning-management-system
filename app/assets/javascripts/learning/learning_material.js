$('document').ready(function () {
	// $('.baigiang-thumbnail').on('click', function (event) {
	// 	// e.preventDefault();
	// 	event.stopPropagation();
	// 	event.stopImmediatePropagation();

	// 	console.log('Clicked');
	// 	var baigiang_id = $(this).data('baigiang-id');
	// 	console.log(baigiang-id)
	// })
	$('#modal_materials').on('click', function (event) {
		event.preventDefault();
		var target = $(event.target);
		var classes = target.attr('class');
		// if (target.attr('class')){
		// var baigiang_id = target.data('baigiang-id');
		// hide all baigiang-ids content
		console.log(target)			
		// show clicked baigiang-id content
		// }

		console.log('Clicked');
	})
})

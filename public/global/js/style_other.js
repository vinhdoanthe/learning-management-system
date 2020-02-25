
$(document).ready(function(){
	$('#product1').owlCarousel({
		items:1,
	    loop:true,
	    margin:10,
	    // nav:true,
        autoplayHoverPause:true,
        autoplay:true,
        autoplayTimeout:10000,
	});

	$('#product2').owlCarousel({
		items:1,
	    loop:true,
	    margin:10,
	    // nav:true,
        autoplayHoverPause:true,
        autoplay:true,
        autoplayTimeout:10000,
	});

	$('#product3').owlCarousel({
		items:1,
	    loop:true,
	    margin:10,
	    // nav:true,
        autoplayHoverPause:true,
        autoplay:true,
        autoplayTimeout:10000,
	});

	$(".bl-content ul li p").click(function(){
		$(".bl-content ul li p").removeClass('active');
	  	$(this).addClass("active");
	});

	$('#owl-carousel1').owlCarousel({
	    loop:true,
	    margin:30,
	    nav:true,
	    autoplay:true,
		autoplayTimeout:5000,
		autoplayHoverPause:true,
	    responsive:{
	        0:{
	            items:1
	        },
	        600:{
	            items:2
	        },
	        1000:{
	            items:3
	        }
	    }
	})
});

$(function(){
    // Enables popover
    $("[data-toggle=popover]").popover();
});

'use strict';

;( function ( document, window, index )
{
	var inputs = document.querySelectorAll( '.inputfile' );
	Array.prototype.forEach.call( inputs, function( input )
	{
		var label	 = input.nextElementSibling,
			labelVal = label.innerHTML;

		input.addEventListener( 'change', function( e )
		{
			var fileName = '';
			if( this.files && this.files.length > 1 )
				fileName = ( this.getAttribute( 'data-multiple-caption' ) || '' ).replace( '{count}', this.files.length );
			else
				fileName = e.target.value.split( '\\' ).pop();

			if( fileName )
				label.querySelector( 'span' ).innerHTML = fileName;
			else
				label.innerHTML = labelVal;
		});

		// Firefox bug fix
		input.addEventListener( 'focus', function(){ input.classList.add( 'has-focus' ); });
		input.addEventListener( 'blur', function(){ input.classList.remove( 'has-focus' ); });
	});
}( document, window, 0 ));

(function(){
	$('.FlowupLabels').FlowupLabels({
		
		// Handles the possibility of having input boxes prefilled on page load
		feature_onInitLoad: true, 
		
		// Class when focusing an input
		class_focused: 		'focused',
		// Class when an input has text entered
		class_populated: 	'populated'	
	});
})();



















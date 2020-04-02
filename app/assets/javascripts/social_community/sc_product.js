
$(document).ready(function(){
  function get_student_product(data){
  $.ajax({
    method: 'GET',
    url: '/user/student_product',
    data: data,
    dataType: 'script'
  })
}
$('.owl-carousel').owlCarousel({
    loop:true,
    margin:10,
  nav: true,
    navText : ['<i class="fa fa-chevron-left" aria-hidden="true"></i>','<i class="fa fa-chevron-right" aria-hidden="true"></i>'],
    responsive:{
        0:{
            items:1
        },
        600:{
            items:3
        },
        1000:{
            items:4
        }
    }
})

})

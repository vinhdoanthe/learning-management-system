function readURL(input, target) {
  if (input.files) {
    $.each(input.files, function (i, photo) {
      var reader = new FileReader();
      reader.onload = function (e) {
        $(target).append('<img class="photo_review" src="' + e.target.result + '" alt="" />');
      }

      reader.readAsDataURL(photo);    
    })
  } 
}

function reviewPhotoUpload (target, preview){
  $(target).change(function(){
    $(preview).html('');
    readURL(this, preview)
  })
}
$(document).ready(function(){
  reviewPhotoUpload('#slider-image', '#slider-image-preview');
  reviewPhotoUpload('#slider-logo', '#slider-logo-preview');
  reviewPhotoUpload('#slider-thumbnail', '#slider-thumbnail-preview');

  $('#contest-slider-form').on('click', '#update-slider-button', function(){
    var data = new FormData();
    id = $('input[name="slider-id"]').val();
    title = $('#slider-title').val();
    image = '';
    logo = '';
    thumbnail = '';

    if ($('#slider-logo')[0].files.length > 0) {
      logo = $('#slider-logo')[0].files[0];
    }

    if ($('#slider-image')[0].files.length > 0) {
      image = $('#slider-image')[0].files[0];
    }

    if ($('#slider-thumbnail')[0].files.length > 0) {
      thumbnail = $('#slider-thumbnail')[0].files[0];
    }

    is_publish = 'false';
    if ($('#slider-publish').is(':checked')){
      is_publish = 'true';
    }
    
    image_side = $('#slider-image-side').val();

    data.append('id', id);
    data.append('title', title);
    data.append('image', image);
    data.append('logo', logo);
    data.append('image_side', image_side);
    data.append('thumbnail', thumbnail);
    data.append('is_publish', is_publish);

    $.ajax({
      method: "POST",
      url: '/adm/contest/contest_sliders/update_slider',
      data: data,
      contentType: false,
      processData: false,
      success: function(res){
        display_response_noti(res);
        if(res.type == 'success'){
        location.reload();
        }
      }
    })
  })
})

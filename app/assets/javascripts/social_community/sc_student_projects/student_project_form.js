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

var getBatchSubject = () => {
  batch_id = $('#student_project_batch').val();
  $.ajax({
    method: "GET",
    url: `/learning/student_batch_subjects?batch_id=${ batch_id }`,
    success: function(res){
      html = ''
      $.each(res, function(index, subject) {
        html += `<option value=${ subject[0] }>${ subject[1]}</option>`
      })
      $("#student_project_subject").html(html)
    }
  })
}

$("#edit_video_infomation").ready(function() {
  getBatchSubject();

  $('#student_project_batch').on('change', function(){
    getBatchSubject();
  })
  $('.project_detail_select').append('<span class="fa fa-caret-down" style="position: absolute; right: 30px; top: 30%"></span>');
  $('.upload_project_presentation').on('click', function(e) {
    if ((e.target !== this) && ($(e.target).is($('#download-presentation'))))
      return;

    $('#upload_project_presentation').trigger('click');
    $('#upload_project_presentation').on('change', function() {
      var ext = this.value.match(/\.(.+)$/)[1];
      if (['ppt', 'pptx', 'pdf'].includes(ext)) {
        if ($('#upload_project_presentation').get(0).files.length > 0) {
          $('#presentation_had_change').val('1');
          $('.project_presentation_file_name').html("<span style='font-size: 16px; font-weight: 600'>" + $('#upload_project_presentation')[0].files[0].name.substring(0, 20) + "...<span>")
        }
      } else {
        $('#upload_project_presentation').val('');
        alert('File không phù hợp! Chỉ hỗ trợ file đuôi "ppt", "pptx", "pdf"')
      };
    })
  })
  $('.upload_project_video').on('click', function(e) {
    $('#upload_project_video').trigger('click');
    $('#upload_project_video').on('change', function() {
      var ext = this.value.match(/\.(.+)$/)[1];
      if (['m4v', 'avi', 'mpg', 'mp4', 'webm'].includes(ext)) {
        $('#video_had_change').val('1');
        if ($('#upload_project_video').get(0).files.length > 0) {
          $('.project_video_name_blank').html("<span style='font-size: 16px; font-weight: 600'>" + $('#upload_project_video')[0].files[0].name.substring(0, 20) + "...<span>") 
        }
      } else {
        $('#upload_project_video').val('');
        alert('File không phù hợp! Chỉ hỗ trợ file đuôi "m4v", "avi","mpg","mp4", "webm"')
      }
    })
  })
  $('.upload_project_file').on('click', function() {
    $('#upload_project_file').data('val', $('#upload_project_file').val());
    $('#upload_project_file').show();
    $("#upload_project_file").attr("readonly", false);
    $('#upload_project_file').select();
    $('#upload_project_file').focus();
    $('.no_link_file').hide();
  })

  $('#upload_project_file').blur(function() {
    if ($('#upload_project_file').val().length === 0) {
      if ($('#upload_project_file').data('val').length > 0) {
        $('#upload_project_file').val($('#upload_project_file').data('val'));
      } else {
        $('#upload_project_file').hide();
        $('.no_link_file').show();
      }
    } else {
      $('#upload_project_file').show();
      $('.no_link_file').hide();
    }
  })
})

$("#upload_project_thumbnail").change(function () {
  $('#upload_project_thumbnail_preview').html('');    
  readURL(this, '#upload_project_thumbnail_preview');

});

$(document).ready(function(){
  function get_student_projects(batch_id){
    $.ajax({
      method: 'GET',
      url: '/social_community/student_projects?batch_id=' + batch_id,
      dataType: 'script'
    })
  }

  $('#student_projects_li').one('click', function(){
    $('.waiting_loading').height(window.windowHeight);
    batch_id = $(this).data('batch-id')
    get_student_projects(batch_id)
  })



  $('.upload_project').on('click', function(){
    $('#upload_project_subject').val($(this).parent().find($('input[name="upload_project_subject"]')).val())
    $('#upload_project_bar').html('<progress id="progressBar" value="0" max="100" style="width: 100%; height: 10px;"></progress>');
    $('#upload_project_bar').hide()
  })
  $('#upload_project_confirm').on('click', function(){
    $('#upload_progress_bar').show()
    var data = new FormData();
    subject_id = $('#upload_project_subject').val()
    student_id = $('#upload_project_selection').val()
    data.append('student_id', student_id)
    file = $('input[name="project_video"]').get(0).files[0]
    if(file == undefined){ file = ''}
    data.append('file', file)
    title = $('input[name="project_name"]').val()
    description = $('textarea[name="project_description"]').val()
    data.append('title', title)
    data.append('description', description)
    slide = $('input[name="project_slide"]').val()
    data.append('slide', slide)
    link = $('input[name="project_action"]').val()
    data.append('link', link)
    batch_id = $('input[name="active_batch"]').val()
    data.append('batch_id', batch_id)
    data.append('subject_id', subject_id)

    $.ajax({
      method: 'POST',
      url: '/social_community/youtube_upload',
      data: data,
      contentType: false,
      processData: false,
      timeout: 6000000,
      success: function(res){
        if (res.type == 'success'){
          $('#upload_progress_bar').html('<span class="upload_done">' + res.message + '</span>')
        }else{
          $('#upload_progress_bar').html('<span class="upload_fail">' + res.message + '</span>');
        }
      },
      xhr: function(){
        //Get XmlHttpRequest object
        var xhr = $.ajaxSettings.xhr() ;
        //Set onprogress event handler
        xhr.upload.onprogress = function(data){
          var perc = Math.round((data.loaded / data.total) * 100);
          $('#progressBar').val(perc);
          if (perc === 100){
            $('#upload_progress_bar').html('<div class="progress"><div class="progress-bar progress-bar-striped progress-bar-animated" role="progressbar" aria-valuenow="75" aria-valuemin="0" aria-valuemax="100" style="width: 100%"></div></div>')
          }
        };
        return xhr ;
      },
    })
  })

  $('.student_project_show').click(function(){
    //project_id = $(this).parent().parent().find($('input[name="student_project_id"]')).val()
    project_id = $(this).data('project');
    $.ajax({
      method: 'GET',
      url: '/social_community/student_project_detail?project_id=' + project_id,
      dataType: 'script'
    })
  })

  $('.edit_project').click(function(){
    project_id = $(this).data('project');
    $.ajax({
      method: 'GET',
      url: '/social_community/edit_student_project?project_id=' + project_id,
      dataType: 'script'
    })
  })

  $('.public_project').click(function(){
    project_id = $(this).data('project');
    $.ajax({
      method: 'POST',
      url: '/social_community/update_student_project',
      data: { project_id: project_id, permission: 'public', state: 'publish' },
      sucess: function(res){
        display_noti(res)
      }
    })
  })
})

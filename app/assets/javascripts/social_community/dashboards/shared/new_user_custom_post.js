$(document).ready(function(){
  $('#user-custom-post-images').change(function(){
    if (window.File && window.FileList && window.FileReader) {
      const preview = $('#files-preview')
      const files = $('#user-custom-post-images')[0].files
      fl = files.length
      if (fl > 0) {
        for (let i=0; i<fl; i++) {
          var file = files[i];
          //Only pics
          if (!file.type.match('image')) continue;
          var picReader = new FileReader();
          picReader.addEventListener("load", function (event) {
            var picFile = event.target;
            var div = document.createElement("div");
            div.setAttribute("id", "new_user_cutom_post_image_"+i)
            div.innerHTML = "<img class='thumbnail rounded float-left preview' src='" + picFile.result + "'" + "title='" + picFile.name + "'/>";
            preview.append(div, null);
          });
          //Read the image
          picReader.readAsDataURL(file);
        }
      }
    } else {
      alert("Your browser does not support File API");
    }
  })
})

addEventListener("direct-upload:initialize", event => {
  const { detail } = event
  const { id } = detail
  const target_element_id = "new_user_cutom_post_image_" + (id-1)
  const target = $("#"+target_element_id)
  target.append(`
    <div id="direct-upload-${id}" class="direct-upload direct-upload--pending">
      <div id="direct-upload-progress-${id}" class="direct-upload__progress" style="width: 0%"></div>
      <span class="direct-upload__filename"></span>
    </div>
  `)
})

addEventListener("direct-upload:start", event => {
  const { id } = event.detail
  const element = document.getElementById(`direct-upload-${id}`)
  element.classList.remove("direct-upload--pending")
})

addEventListener("direct-upload:progress", event => {
  const { id, progress } = event.detail
  const progressElement = document.getElementById(`direct-upload-progress-${id}`)
  progressElement.style.width = `${progress}%`
})

addEventListener("direct-upload:error", event => {
  event.preventDefault()
  const { id, error } = event.detail
  const element = document.getElementById(`direct-upload-${id}`)
  element.classList.add("direct-upload--error")
  element.setAttribute("title", error)
})

addEventListener("direct-upload:end", event => {
  const { id } = event.detail
  const element = document.getElementById(`direct-upload-${id}`)
  element.classList.add("direct-upload--complete")
})

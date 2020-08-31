$(document).ready(function(){
  $('#images').change(function(){
    if (window.File && window.FileList && window.FileReader) {
      const files = $('#images')[0].files
      if (validateFileTypes(files)) {
        processFiles(files);
      }
    } else {
      alert("Your browser does not support File API");
    }
  })
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

const validateFileTypes = files => {
  if (files.length == 0) {
    return false;
  }
  const allowedFileTypes = ['image/png', 'image/jpeg', 'image/webp', 'image/gif']
  for (let i = 0; i<files.length; i++) {
    if (files[i].size >= 4000000 || !(allowedFileTypes.includes(files[i].type))) {
      alert("Hệ thống chỉ cho phép đăng ảnh định dạng: png, jpg, jpeg, gif, webp với dung lượng nhỏ hơn 4MB!");
      return false;
    }
  }
  return true;
}

const processFiles = files => {
  fl = files.length
  if (fl > 0) {
    const preview = $('#images-preview')
    for (let i=0; i<fl; i++) {
      var file = files[i];
      //Only pics
      if (!file.type.match('image')) continue;
      var picReader = new FileReader();
      picReader.addEventListener("load", function (event) {
        var picFile = event.target;
        var div = document.createElement("div");
        //div.setAttribute("id", "new_user_cutom_post_image_"+i)
        div.innerHTML = "<img class='thumbnail rounded float-left preview' src='" + picFile.result + "'" + "title='" + picFile.name + "'/>";
        preview.append(div, null);
      });
      //Read the image
      picReader.readAsDataURL(file);
    }
  }
}


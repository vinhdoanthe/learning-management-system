$(document).ready(() => $(document).on('mousedown', '.save-action', function(e) { // triggers also when submitting form with enter
  for (let instance in CKEDITOR.instances) {
    const editor = CKEDITOR.instances[instance];
    if (editor.checkDirty()) {
      editor.updateElement();
    }
  }
  return true;
}));

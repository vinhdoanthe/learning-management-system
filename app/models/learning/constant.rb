module Learning::Constant

  STUDENT_BATCH_STATUS_ON = 'on'
  STUDENT_BATCH_STATUS_OFF = 'off'
  STUDENT_BATCH_STATUS_SAVE = 'save'

  module Course
    MATERIAL_TYPE_VIDEO = 'video'
    MATERIAL_TYPE_FILE = 'file'

    LEARNING_TYPE_TEACH = 'teach'
    LEARNING_TYPE_REVIEW = 'review'
  end

  module Batch
    module Session
      STATE_DRAFT = 'draft'
      STATE_DONE = 'done'
      STATE_CONFIRM = 'confirm'
      STATE_CANCEL = 'cancel'
    end
  end
end
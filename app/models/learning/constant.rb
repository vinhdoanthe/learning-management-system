module Learning::Constant

  STUDENT_BATCH_STATUS_ON = 'on'
  STUDENT_BATCH_STATUS_OFF = 'off'
  STUDENT_BATCH_STATUS_SAVE = 'save'

  module Material
    MATERIAL_TYPE_VIDEO = 'video'
    MATERIAL_TYPE_FILE = 'file'

    MATERIAL_TYPE_TEACH = 'teach'
    MATERIAL_TYPE_REVIEW = 'review'

    QUESTION_TEXT_RESPONSE = 'text'
    QUESTION_SINGLE_CHOICE = 'single'
    QUESTION_MULTIPLE_CHOICES = 'multiple'

  end

  module Batch
    module Session
      STATE_DRAFT = 'draft'
      STATE_DONE = 'done'
      STATE_CONFIRM = 'confirm'
      STATE_CANCEL = 'cancel'

      MINUTES_BEFORE_ALLOW_CHECKIN = 15

      CHECKIN_STATE_NONE = 'none'
      CHECKIN_STATE_GOOD = 'good'
      CHECKIN_STATE_BAD = 'bad'
    end
  end
end
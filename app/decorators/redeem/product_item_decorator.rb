class Redeem::ProductItemDecorator < SimpleDelegator

  def input_date_frm
    return '' if !input_date

    input_date.strftime(I18n.t('date.formats.default'))
  end

  def release_date_frm
    return '' if !release_date

    release_date.strftime(I18n.t('date.formats.default'))
  end
end

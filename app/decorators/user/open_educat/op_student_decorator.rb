class User::OpenEducat::OpStudentDecorator < SimpleDelegator

  def display_gender
    if gender == 'm'
      I18n.t('public_profile.gender_male')
    elsif gender == 'f'
      I18n.t('public_profile.gender_female')
    else
      ''
    end
  end
end

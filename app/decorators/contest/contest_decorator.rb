class Contest::ContestDecorator < SimpleDelegator
  include ActionView::Helpers
  include Rails.application.routes.url_helpers

  def display_month_active
    months = contest_prizes.pluck(:month_active).uniq
    months.flatten!
    display = '<label>Choose month</label>'

    for i in 1..12
      if months.include? (i.to_s)
        display += "<div class='form-check'>
            <input class='form-check-input' id='contest_prize_month_#{ i.to_s }' value='#{ i.to_s }' type='checkbox' name='contest_prize_month[]'>
            <label for='contest_prize_month_#{ i.to_s }'>#{ i.to_s }</label>
          </div>"
      else
        display += "<div class='form-check'>
            <input class='form-check-input' id='contest_prize_month_#{ i.to_s }' value='#{ i.to_s }' type='checkbox' name='contest_prize_month[]'>
            <label for='contest_prize_month_#{ i.to_s }'>#{ i.to_s }</label>
          </div>"
      end
    end

    display
  end

  def display_like_share
    like = project_criterions.joins(:contest_criterion).where(tk_contest_criterions: { name: 'like' }).first&.number
    share = project_criterions.joins(:contest_criterion).where(tk_contest_criterions: { name: 'share' }).first&.number
    "<li><i class='icon16-like'></i><span>#{ like.to_i }</span></li>
    <li><i class='icon16-share'></i><span>#{ share.to_i }</span></li>
    <li><i class='icon16-eye'></i><span>#{ views.to_i }</span></li>"
  end

  def display_link_project
    display = ''
    if project_show_video.present?
      display = '<div class="c-widget"> <div class="c-widget__content"> <div class="c-link-grid"> <ul>'
      if introduction_video.present?
        display += "<li> <div class='c-link-item'><a id='project-show-introduction-video' data-project=#{ id }><i class='icon48-youtube'></i><span class='c-link-item__text'><span class='c-link-item__title'>#{ I18n.t('Contest.Products.video')}</span><span class='c-link-item__desc'>#{ I18n.t('Contest.Products.introduction') }</span></span><i class='icon-medium-arrow-right'></i></a></div> </li> "
      end

      if presentation.present?
        display += " <li> <div class='c-link-item'><a id='project-show-presentation'><i class='icon48-file'></i><span class='c-link-item__text'><span class='c-link-item__title'>#{ I18n.t('Contest.Products.document') }</span><span class='c-link-item__desc'>#{ I18n.t('Contest.Products.presentation')}</span></span><i class='icon-medium-arrow-right'></i></a></div> </li> "
      end

      display += ' </ul> </div> </div> </div> '
      display = '' if presentation.blank? && introduction_video.blank?
    else
      if introduction_video.present?
        if presentation.present?
          display = '<div class="c-widget"> <div class="c-widget__content"> <div class="c-link-grid"> <ul>'
          display += " <li> <div class='c-link-item'><a id='project-show-presentation'><i class='icon48-file'></i><span class='c-link-item__text'><span class='c-link-item__title'>#{ I18n.t('Contest.Products.document') }</span><span class='c-link-item__desc'>#{ I18n.t('Contest.Products.presentation')}</span></span><i class='icon-medium-arrow-right'></i></a></div> </li> "
          display += ' </ul> </div> </div> </div> '
        end
      end
    end

    display
  end

  def display_project_thumbnail
    display = ''

    if thumbnail.present?
      display = "<img src='#{ thumbnail }'" 
    elsif image.attached?
      display = "<img src='" + rails_blob_path(image, disposition: "attachment", only_path: true) + "'>"
    else
      display = "<img src='/contest/upload/product-small_2.jpg' alt='product'>"
    end

    display
  end
end

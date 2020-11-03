class Adm::Contest::ContestSlidersController < Adm::AdmController
  skip_before_action :verify_authenticity_token, only: [:update_slider, :delete_slider]

  def index
    @sliders = Contest::ContestSlider.all
  end

  def new
  end

  def update_slider
    result = Adm::Contest::ContestSlidersService.new.update_slider params

    render json: result
  end

  def remove_slider
    slider = Contest::ContestSlider.where(id: params[:id]).first

    if slider.blank?
      render json: { type: 'danger', message: 'slider k ton tai' } 
    else
      if slider.is_publish
        render json: { type: 'danger', message: 'khong the xoa slider dang active' }
      else
        if slider.delete
          render json: { type: 'success', message: 'Xoa thanh cong' }
        else
          redner json: { type: 'danger', message: 'da co loi xay ra! Vui long thu lai sau'}
        end
      end
    end
  end

  def slider_detail
    @slider = Contest::ContestSlider.where(id: params[:id]).first
  end
end

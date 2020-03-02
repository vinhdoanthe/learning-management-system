class Learning::Batch::SessionsController < ApplicationController
    def add_photo_attachment
    	@session = Learning::Batch::OpSession.find(params[:session_id])
    	if @session.photos.attach(params[:photos])
    		render json: {type: 'success', message: 'Đăng ảnh thành công!' }
    	else
    		render json: {type: 'danger', message: 'Đã có lỗi xảy ra! Thử lại sau!'}
    	end
    	
    end
end
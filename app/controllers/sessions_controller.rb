class SessionsController < ApplicationController
    def add_photo_attachment
    	@session = Learning::Batch::OpSession.find(params[:session_id])
    	@session.photos.attach(params[:photos][:photo])
    end
end
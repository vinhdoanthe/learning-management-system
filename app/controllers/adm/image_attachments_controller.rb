class Adm::ImageAttachmentsController < Adm::AdmController
  def delete_image_attachment
    image = ActiveStorage::Blob.find_signed(params[:blob_id])
    attachment = ActiveStorage::Attachment.where(blob_id: image.id).first
    if attachment.nil?
      respond_to do |format|
        format.json {
          render json: {
            :success => true,
            :blob_id => params[:blob_id]
          }
        }
      end
    else
      if attachment.purge
        respond_to do |format|
          format.json {
            render json: {
              :success => true,
              :blob_id => params[:blob_id]
            }
          }
        end
      else
        respond_to do |format|
          format.json {
            render json: {
              :success => false
            }
          }
        end
      end
    end
  end
end

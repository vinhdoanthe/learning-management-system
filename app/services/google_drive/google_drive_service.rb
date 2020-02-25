module Learning
  class GoogleDriveService
    require "google/apis/drive_v3"
    require "googleauth"
    require "googleauth/stores/file_token_store"
    require "fileutils"

    OOB_URI = "localhost:3000/oauth2callback"
    attr_writer :authorizer, :drive, :redirect_uri, :credentials


    OOB_URI = "urn:ietf:wg:oauth:2.0:oob".freeze
    APPLICATION_NAME = "Google Drive API".freeze
    CREDENTIALS_PATH = "credentials.json".freeze
    TOKEN_PATH = "token.yaml".freeze
    SCOPE = Google::Apis::DriveV3::AUTH_DRIVE_METADATA_READONLY

    def authorize
      client_id = Google::Auth::ClientId.from_file CREDENTIALS_PATH
      token_store = Google::Auth::Stores::FileTokenStore.new file: TOKEN_PATH
      authorizer = Google::Auth::UserAuthorizer.new client_id, SCOPE, token_store
      user_id = "default"
      credentials = authorizer.get_credentials user_id
      if credentials.nil?
        url = authorizer.get_authorization_url base_url: OOB_URI
        puts "Open the following URL in the browser and enter the " \
         "resulting code after authorization:\n" + url
        code = gets
        credentials = authorizer.get_and_store_credentials_from_code(
            user_id: user_id, code: code, base_url: OOB_URI
        )
      end
      credentials
    end

    # Initialize the API
    drive_service = Google::Apis::DriveV3::DriveService.new
    drive_service.client_options.application_name = APPLICATION_NAME
    drive_service.authorization = authorize

    # def authorization_url
    #   @authorizer.get_authorization_url(base_url: OOB_URI)
    # end
    #
    # def get_credentials
    #   @credentials
    # end
    #
    # def set_authorization
    #   @drive.authorization = @credentials
    # end
    #
    # def get_drive
    #   @drive
    # end
    #
    # def save_credentials(code)
    #   user_id = 'darazone'
    #   @credentials = @authorizer.get_and_store_credentials_from_code(
    #       user_id: user_id, code: code, base_url: OOB_URI)
    #   @drive.authorization = @credentials
    # end

    # def list_files(options = {})
    #   @drive.list_files(options: options)
    # end
    #
    # def upload(file, options = {})
    #   # file[:parent_ids] = [{id: 'id'}]
    #   file_obj = Google::Apis::DriveV2::File.new({
    #                                                  title: file[:title],
    #                                                  parents: file[:parent_ids]
    #                                              })
    #   f = @drive.insert_file(file_obj, upload_source: file[:path])
    #   f.id
    # rescue
    #   nil
    # end
    #
    # def delete(id, options = {})
    #   @drive.delete_file(id)
    # end
    #
    # def update(id, file, options = {})
    #   @drive.patch_file(id, file)
    # end

    def get(id, options = {})
      @drive.get_file(id)
    end

    # def list_children_files(parent_id, options = {})
    #   @drive.list_children(parent_id, options: options).items
    # end
  end
end
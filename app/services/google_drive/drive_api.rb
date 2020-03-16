module GoogleDrive
  class DriveApi

    require "google/apis/drive_v3"
    require "googleauth"
    require "googleauth/stores/file_token_store"
    require "fileutils"

    OOB_URI = "urn:ietf:wg:oauth:2.0:oob".freeze
    APPLICATION_NAME = "TEKY LMS Drive API".freeze
    CREDENTIALS_PATH = "config/google_drive/credentials.json".freeze
    TOKEN_PATH = "config/google_drive/token.yaml".freeze
    SCOPE = [Google::Apis::DriveV3::AUTH_DRIVE, Google::Apis::DriveV3::AUTH_DRIVE_PHOTOS_READONLY]

    def self.get_drive_api_instance
      if @@drive_instance.nil?
        @@drive_instance = GoogleDrive::DriveApi.new
        @@drive_instance.initialize_drive_api
      end
      @@drive_instance
    end

    def get_pretty_file(file_id)
      user_permission = {type: "anyone", role: "reader"}
      @drive_service.create_permission(file_id, user_permission, send_notification_email: false, fields: 'id')

      capabilities = {"canComment": false,
                      "canCopy": false,
                      "canDownload": false,
                      "canShare": false
      }
      @drive_service.update_file(file_id, capabilities, fields: 'id')
      @drive_service.get_file(file_id, fields: 'id, webViewLink, iconLink, hasThumbnail, thumbnailLink')
    end

    def get_published_version(file_id)
      @file = @drive_service.get_file(file_id, fields: '*')
      @revision = @drive_service.get_revision(file_id, @file.head_revision_id, fields: '*')

      revision_object = {published: true, published_outside_domain: true, publish_auto: true}
      @drive_service.update_revision(file_id, @file.head_revision_id, revision_object)
      @file = @drive_service.get_file(file_id, fields: '*')
      @revision = @drive_service.get_revision(file_id, @file.head_revision_id, fields: '*')

      # if @revision.nil?
      #
      # else
      #
      # end
      binding.pry
    end

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

    def initialize_drive_api
      @drive_service = Google::Apis::DriveV3::DriveService.new
      @drive_service.client_options.application_name = APPLICATION_NAME
      @drive_service.authorization = authorize
    end

    private

    @@drive_instance = nil

  end
end

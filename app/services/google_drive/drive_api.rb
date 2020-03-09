module GoogleDrive
  class DriveApi
    require "google/apis/drive_v3"
    require "googleauth"
    require "googleauth/stores/file_token_store"
    require "fileutils"

    OOB_URI = "urn:ietf:wg:oauth:2.0:oob".freeze
    APPLICATION_NAME = "TEKY LMS Drive API".freeze
    CREDENTIALS_PATH = "config/google_drive/credentials.json".freeze
    # The file token.yaml stores the user's access and refresh tokens, and is
    # created automatically when the authorization flow completes for the first
    # time.
    TOKEN_PATH = "config/google_drive/token.yaml".freeze
    SCOPE = Google::Apis::DriveV3::AUTH_DRIVE

    ##
    # Ensure valid credentials, either by restoring from the saved credentials
    # files or intitiating an OAuth2 authorization. If authorization is required,
    # the user's default browser will be launched to approve the request.
    #
    # @return [Google::Auth::User::RefreshCredentials] OAuth2 credentials
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


    # List the 10 most recently modified files.
    def test_list_10_files
      initialize_drive_api
      response = @@drive_service.list_files(page_size: 10,
                                            fields: "nextPageToken, files(id, name)")
      puts "Files:"
      puts "No files found" if response.files.empty?
      response.files.each do |file|
        puts "#{file.name} (#{file.id})"
      end
    end

    def get_file(file_id)
      user_permission = {type: "anyone", role: "reader"}
      @@drive_service.create_permission(file_id, user_permission, send_notification_email: false, fields: 'id')

      capabilities = { "canAddChildren": false,
                       "canChangeCopyRequiresWriterPermission": false,
                       "canChangeViewersCanCopyContent": false,
                       "canComment": false,
                       "canCopy": false,
                       "canDelete": false,
                       "canDeleteChildren": false,
                       "canDownload": false,
                       "canEdit": false,
                       "canListChildren": false,
                       "canModifyContent": false,
                       "canMoveChildrenOutOfTeamDrive": false,
                       "canMoveChildrenOutOfDrive": false,
                       "canMoveChildrenWithinTeamDrive": false,
                       "canMoveChildrenWithinDrive": false,
                       "canMoveItemIntoTeamDrive": false,
                       "canMoveItemOutOfTeamDrive": false,
                       "canMoveItemOutOfDrive": false,
                       "canMoveItemWithinTeamDrive": false,
                       "canMoveItemWithinDrive": false,
                       "canMoveTeamDriveItem": false,
                       "canReadRevisions": false,
                       "canReadTeamDrive": false,
                       "canReadDrive": false,
                       "canRemoveChildren": false,
                       "canRename": false,
                       "canShare": false,
                       "canTrash": false,
                       "canTrashChildren": false,
                       "canUntrash": false}
      # options = {
      #     copyRequiresWriterPermission: true,
      #     viewersCanCopyContent: false
      # }
      @@drive_service.update_file(file_id, capabilities, fields: 'id')

      @@drive_service.get_file(file_id, fields: 'webViewLink')
    end

    private

    # Initialize the API
    def initialize_drive_api
      @@drive_service = Google::Apis::DriveV3::DriveService.new
      @@drive_service.client_options.application_name = APPLICATION_NAME
      @@drive_service.authorization = authorize
    end
  end
end

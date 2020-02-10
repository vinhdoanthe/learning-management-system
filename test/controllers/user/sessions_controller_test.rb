require 'test_helper'

class User::SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get user_sessions_new_url
    assert_response :success
  end

end

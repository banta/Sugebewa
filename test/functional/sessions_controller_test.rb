require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  test "should get forgot_password" do
    get :forgot_password
    assert_response :success
  end

  test "should get login" do
    get :login
    assert_response :success
  end

  test "should get resend_mail" do
    get :resend_mail
    assert_response :success
  end

end

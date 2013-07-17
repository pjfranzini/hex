require 'test_helper'

class ColorsControllerTest < ActionController::TestCase
  test "should get display" do
    get :display
    assert_response :success
  end

  test "should get score" do
    get :score
    assert_response :success
  end

end

require 'test_helper'

class ColorsControllerTest < ActionController::TestCase
  test "should get display" do
    get :display
    assert_response :success
  end

  test "should get score" do
    post :score, {:original_color => '#fff',:players_color => '#fff'}
    assert_response :success
  end

  test "score is appropriate (worst)" do
    post :score, {:original_color => '#000',:players_color => '#fff'}
    assert_in_delta(0, assigns(:score), 0.001)
  end

  test "score is appropriate (best)" do
    post :score, {:original_color => '#000',:players_color => '#000'}
    assert_in_delta(100, assigns(:score), 0.001)
  end

end

require 'test_helper'

class MapControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get seize" do
    get :seize
    assert_response :success
  end

  test "should get independence" do
    get :independence
    assert_response :success
  end

  test "should get betray" do
    get :betray
    assert_response :success
  end

end

require "test_helper"

class Public::RatingControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get public_rating_create_url
    assert_response :success
  end
end

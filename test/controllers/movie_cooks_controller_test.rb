require "test_helper"

class MovieCooksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get movie_cooks_index_url
    assert_response :success
  end
end

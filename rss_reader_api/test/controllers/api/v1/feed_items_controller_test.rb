require "test_helper"

class Api::V1::FeedItemsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_feed_items_index_url
    assert_response :success
  end

  test "should get toggle_read" do
    get api_v1_feed_items_toggle_read_url
    assert_response :success
  end
end

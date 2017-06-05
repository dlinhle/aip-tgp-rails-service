require 'test_helper'

class DataDumpControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get data_dump_index_url
    assert_response :success
  end

end

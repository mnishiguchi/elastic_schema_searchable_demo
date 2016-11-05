require 'test_helper'

class SchemaSearchesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get schema_searches_index_url
    assert_response :success
  end

end

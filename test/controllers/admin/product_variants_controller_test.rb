require "test_helper"

class Admin::ProductVariantsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_product_variants_index_url
    assert_response :success
  end

  test "should get show" do
    get admin_product_variants_show_url
    assert_response :success
  end

  test "should get new" do
    get admin_product_variants_new_url
    assert_response :success
  end

  test "should get edit" do
    get admin_product_variants_edit_url
    assert_response :success
  end
end

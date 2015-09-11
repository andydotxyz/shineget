require 'test_helper'

class ItemsControllerTest < ActionController::TestCase
  setup do
    @item = items(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create item" do
    assert_difference('Item.count') do
      post :create, item: { notes: @item.notes, price: @item.price, url: @item.url, user_id: @item.user_id }
    end

    assert_redirected_to item_path(assigns(:item))
  end

  test "should rediret to item" do
    get :show, id: @item
    assert_response :redirect
  end

  test "should destroy item" do
    assert_difference('Item.count', -1) do
      delete :destroy, id: @item
    end

    assert_redirected_to current_user
  end
end

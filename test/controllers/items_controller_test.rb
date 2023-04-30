# frozen_string_literal: true

require 'test_helper'

class ItemsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @category_name_1 = "category_#{rand(1000)}"
    @category_name_2 = "category_#{rand(1000)}"
    @category_1 = Category.create(name: @category_name_1)
    @category_2 = Category.create(name: @category_name_2)
    @item_1 = Item.create(name: 'item_1', category: @category_1)
    @item_2 = Item.create(name: 'item_2', category: @category_1)
    @item_3 = Item.create(name: 'item_3', category: @category_2)
  end

  test 'index with category name' do
    get items_url(category_name: @category_name_1)
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal '201', json['status']
    assert_equal 2, json['data'].size
  end

  test 'index without category name' do
    get items_url
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal '201', json['status']
    assert_equal 3, json['data'].size
  end

  test 'index with unknown category name' do
    get items_url(category_name: "unknown_category_name")
    assert_response :not_found
    json = JSON.parse(response.body)
    assert_equal '404', json['status']
    assert_equal 'requested category does not exist', json['message']
  end

  test 'create item with existing category' do
    assert_difference('Item.count') do
      post items_url, params: { name: 'new_item', category_name: @category_name_1 }
      assert_response :success
      json = JSON.parse(response.body)
      assert_equal '201', json['status']
      assert_equal 'new_item', json['data']['name']
    end
  end

  test 'create item with new category' do
    assert_difference('Item.count') do
      post items_url, params: { name: 'new_item', category_name: 'new_category' }
      assert_response :success
      json = JSON.parse(response.body)
      assert_equal '201', json['status']
      assert_equal 'new_item', json['data']['name']
    end
  end

  test 'create item without item name' do
    post items_url, params: { category_name: @category_name_1 }
    assert_response :unprocessable_entity
    json = JSON.parse(response.body)
    assert_equal '422', json['status']
  end
end

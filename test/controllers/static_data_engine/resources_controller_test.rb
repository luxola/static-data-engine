require 'test_helper'

class StaticDataEngine::ResourcesControllerTest < ActionController::TestCase
  include TestData

  setup do
    @routes = StaticDataEngine::Engine.routes
  end

  test '#search' do
    seed_data!

    get :search
    assert_response :unprocessable_entity

    get :search, query: 'q'
    assert_response :unprocessable_entity

    get :search, query: 'q', table: 't'
    assert_response :unprocessable_entity

    get :search, query: 'foo', field: 'attrib1', table: 'test_non_existent'
    assert_response :unprocessable_entity

    get :search, query: 'foo', field: 'attrib1', table: 'test_basic'
    resp = JSON.parse(response.body)

    assert resp['success']
    assert_equal 1, resp['results'].count
    assert_equal 'foo', resp['results'].first['attrib1']
  end
end
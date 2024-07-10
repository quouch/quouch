require 'test_helper'

class RoutesTest < ActionDispatch::IntegrationTest
  test 'should route to api v1 login new' do
    assert_routing '/api/v1/login', { format: :json, controller: 'api/v1/users/sessions', action: 'new' }
  end

  test 'should route to api v1 login create' do
    assert_routing({ method: 'post', path: '/api/v1/login' },
                   { format: :json, controller: 'api/v1/users/sessions', action: 'create' })
  end

  test 'should route to api v1 logout' do
    assert_routing({ method: 'delete', path: '/api/v1/logout' },
                   { format: :json, controller: 'api/v1/users/sessions', action: 'destroy' })
  end

  test 'should route to api v1 users edit' do
    assert_routing 'api/v1/users/edit', { format: :json, controller: 'api/v1/users/registrations', action: 'edit' }
  end

  test 'should route to api v1 update' do
    id = '1'
    assert_routing({ method: 'post', path: "api/v1/update/#{id}" },
                   { format: :json, controller: 'api/v1/users/registrations', action: 'update', id: })
  end
end

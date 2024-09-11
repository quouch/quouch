# frozen_string_literal: true

require 'test_helper'

class ApiHelperTest < ActionView::TestCase
  include ApiHelper

  test 'should format JSON error' do
    response = format_error(status: 422, title: 'Error message')
    assert_equal([{ errors: [{ status: 422, title: 'Error message' }] }, 422], response)
  end
end

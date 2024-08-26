# frozen_string_literal: true

require 'test_helper'

class InviteCodeHelperTest < ActiveSupport::TestCase
  include InviteCodeHelper

  test 'should check that a six letter code is valid' do
    code = 'abcdef'
    assert valid_syntax?(code)
  end

  test 'should check that a six letter code with numbers is valid' do
    code = '123456'
    assert valid_syntax?(code)
  end

  test 'should check that a six letter code with numbers and letters is valid' do
    code = 'abc123'
    assert valid_syntax?(code)
  end

  test 'should check that a six letter code with special characters is invalid' do
    code = 'abcde!'
    assert_not valid_syntax?(code)
  end

  test 'should check that the generated code is valid' do
    code = generate_random_code
    assert valid_syntax?(code)
  end

  test 'should check that a code with less than six letters is invalid' do
    code = 'abcde'
    assert_not valid_syntax?(code)
  end

  test 'should check that a code with more than six letters is invalid' do
    code = 'abcdefg'
    assert_not valid_syntax?(code)
  end
end

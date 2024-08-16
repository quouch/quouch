# frozen_string_literal: true

require 'test_helper'

class JwtTokenHelperTest < ActionView::TestCase
  test 'should raise error when no token is found' do
    # Check that the error is raised when no token is found
    error = assert_raises JwtError do
      jwt_token_is_valid?('')
    end

    assert_equal 'No token found', error.message
  end

  test 'should raise error when the token is invalid' do
    # Check that the error is raised when the token is invalid
    error = assert_raises JwtError do
      jwt_token_is_valid?('invalid_token')
    end

    assert_equal 'Token has an invalid format.', error.message
  end

  test 'should raise error when the token has expired' do
    # Prepare a token
    expired_token = generate_token({ sub: 1, jti: '123', exp: Time.now.to_i - 10 })

    # Check that the error is raised when the token has expired
    error = assert_raises JwtError do
      jwt_token_is_valid?(expired_token)
    end

    assert_equal 'Token has expired.', error.message
  end

  test 'should raise error when the user is not found' do
    # Prepare a token
    token = generate_token({ sub: 11_232, jti: '123', exp: Time.now.to_i + 100 })

    # Check that the error is raised when the user is not found
    error = assert_raises JwtError do
      jwt_token_is_valid?(token)
    end

    assert_equal 'User not found.', error.message
  end

  test 'should raise error when the token does not match the user' do
    # Create a user
    user = FactoryBot.create(:test_user)

    # Prepare a token
    token = generate_token({ sub: user.id, jti: '123', exp: Time.now.to_i + 10 })

    # Check that the error is raised when the token does not match the user
    error = assert_raises JwtError do
      jwt_token_is_valid?(token)
    end

    assert_equal 'Token is invalid.', error.message
  end

  test 'should find user by jwt token' do
    # Create a user
    user = FactoryBot.create(:test_user)

    # Prepare a token
    token = generate_token({ sub: user.id, jti: user.jti, exp: Time.now.to_i + 10 })

    found_user = find_user_by_jwt_token(token)

    assert_equal user.id, found_user.id
  end

  private

  def generate_token(payload)
    token = JWT.encode(payload, Rails.application.credentials.dig(:devise, :jwt_secret_key))

    "Bearer #{token}"
  end
end

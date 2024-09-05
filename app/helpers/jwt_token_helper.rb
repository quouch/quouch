# frozen_string_literal: true

class JwtError < StandardError; end

module JwtTokenHelper
  def find_user_by_jwt_token(token)
    jwt_token_is_valid?(token)
  end

  def jwt_token_is_valid?(token)
    raise JwtError, 'No token found' unless token.present?

    begin
      # The token has the format Bearer <token>. We need to split it to get the token.
      jwt_payload = JWT.decode(token.split.last, Rails.application.credentials.dig(:devise, :jwt_secret_key)).first

      # check if the token is expired or not
      has_expired = Time.at(jwt_payload['exp']).to_i < Time.now.to_i

      return false if has_expired

      # check that the jti matches for the user
      current_user = User.find(jwt_payload['sub'])

      raise JwtError, 'Token is invalid.' if current_user.jti != jwt_payload['jti']

      current_user
    rescue JWT::ExpiredSignature
      raise JwtError, 'Token has expired.'
    rescue JWT::VerificationError
      raise JwtError, 'Token is invalid.'
    rescue JWT::DecodeError
      raise JwtError, 'Token has an invalid format.'
    rescue ActiveRecord::RecordNotFound
      raise JwtError, 'User not found.'
    rescue => e
      raise JwtError, e || 'Something went wrong. Please try again.'
    end
  end
end

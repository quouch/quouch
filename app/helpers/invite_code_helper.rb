# frozen_string_literal: true

module InviteCodeHelper
  def generate_random_code
    SecureRandom.hex(3)
  end

  protected

  def valid_syntax?(invite_code)
    invite_code.match?(/^[a-zA-Z0-9]{6}$/)
  end
end

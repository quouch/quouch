# frozen_string_literal: true

module Users
  class PasswordsController < Devise::PasswordsController
    def update
      super do |resource|
        Rails.logger.error("Password update failed for user. Reasons: #{resource.errors.full_messages}") unless resource.persisted?
      end
    end
  end
end

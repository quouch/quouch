# frozen_string_literal: true

module Users
  class PasswordsController < Devise::PasswordsController
    def update
      super do |resource|
        unless resource.persisted?
          Rails.logger.error("Password update failed for user. Reasons: #{resource.errors.full_messages}")
        end
      end
    end
  end
end

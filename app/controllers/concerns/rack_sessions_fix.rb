# frozen_string_literal: true

# Devise relies on sessions to function.
# Since Rails 7, a session is an ActionDispatch::Session object,
# which is not writable on Rails API apps, because the
# ActionDispatch::Session is disabled
module RackSessionsFix
  extend ActiveSupport::Concern

  # As a workaround, instruct devise to create a fake session hash
  class FakeRackSession < Hash
    def enabled?
      false
    end

    def destroy
    end
  end

  included do
    before_action :set_fake_session

    private

    def set_fake_session
      request.env["rack.session"] ||= FakeRackSession.new
    end
  end
end

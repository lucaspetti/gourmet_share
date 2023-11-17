# frozen_string_literal: true

require 'active_support/concern'

module RSpec
  module AuthHelper
    extend ActiveSupport::Concern

    def user_token(client, user)
      Doorkeeper::AccessToken.find_or_create_for(
        resource_owner: user.id,
        application: client,
        refresh_token: SecureRandom.hex(32),
        expires_in: Doorkeeper.configuration.access_token_expires_in.to_i,
        scopes: 'read'
      )
    end
  end
end

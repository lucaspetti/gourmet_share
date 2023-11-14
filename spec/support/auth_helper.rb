# frozen_string_literal: true

require 'active_support/concern'

module RSpec
  module AuthHelper
    extend ActiveSupport::Concern

    def user_token(user)
      JwtWrapper.encode(user_id: user.id)
    end
  end
end

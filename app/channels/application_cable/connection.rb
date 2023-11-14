module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      return find_user_from_jwt if find_user_from_jwt

      reject_unauthorized_connection
    end

    def find_user_from_jwt
      user_id = fetch_id_from_jwt

      if verified_user = User.find(user_id)
        verified_user
      else
        reject_unauthorized_connection
      end
    end

    def fetch_id_from_jwt
      JwtWrapper.decode(cookies[:_gourmet_share_jwt]).dig('user_id')
    rescue JWT::ExpiredSignature, JWT::DecodeError, JWT::VerificationError
      reject_unauthorized_connection
    end
  end
end

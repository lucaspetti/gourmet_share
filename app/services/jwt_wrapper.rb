# frozen_string_literal: true

class JwtWrapper
  ALGORITHM = 'HS512'
  ISSUER = 'gourmet_share'

  def self.encode(payload)
    JWT.encode(full_payload(payload), ENV['JWT_SECRET'], ALGORITHM)
  end

  def self.decode(token)
    JWT.decode(token, ENV['JWT_SECRET'], true, algorithm: ALGORITHM).first
  end

  def self.full_payload(payload)
    payload.merge(iss: ISSUER, iat: Time.zone.now.to_i, exp: expiration_time, jti: SecureRandom.uuid)
  end

  def self.expiration_time
    30.minutes.from_now.to_i
  end
end

FactoryBot.define do
  factory :client, class: 'Doorkeeper::Application' do
    name { "sample_client" }
    redirect_uri { "https://redirect.me/redirect" }
    uid { SecureRandom.hex }
    secret { SecureRandom.hex }
  end
end

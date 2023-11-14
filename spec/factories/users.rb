FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    first_name { 'Max' }
    last_name { 'Mustermann' }
    password { 'SafePassword!' }
  end
end

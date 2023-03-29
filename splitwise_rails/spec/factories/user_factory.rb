FactoryBot.define do
  factory :user do
    id { SecureRandom.uuid }
    user_name { 'User' }
    password { 'password' }
  end
end
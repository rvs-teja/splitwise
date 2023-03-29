FactoryBot.define do
  factory :group do
    id { SecureRandom.uuid }
    name { 'Group' }
    description { 'Group description' }
    creator { build(:user) }
  end
end
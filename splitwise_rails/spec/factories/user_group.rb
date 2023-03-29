FactoryBot.define do
  factory :user_group do
    id { SecureRandom.uuid }
    user { build(:user) }
    group { build(:group) }
  end
end
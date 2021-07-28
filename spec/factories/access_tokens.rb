FactoryBot.define do
  factory :access_token do
    # token { 'MyString' }
    # token is generated after initialization
    association :user
  end
end

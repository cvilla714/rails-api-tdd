FactoryBot.define do
  factory :article do
    sequence(:title) { |n| "Sample article #{n}" }
    content { 'Sample content' }
    sequence(:slug) { |n| "sample-article-#{n}" }
  end
end

FactoryBot.define do
  sequence :slug do |n|
    "slug#{n}"
  end
end

FactoryBot.define do
  factory :article do
    title { 'Sample article' }
    content { 'Sample content' }
    slug { 'sample-article' }
  end
end

FactoryBot.define do
  sequence :slug do |n|
    "slug#{n}"
  end
end

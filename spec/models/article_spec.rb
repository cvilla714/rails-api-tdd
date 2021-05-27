require 'rails_helper'

RSpec.describe Article, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  it('tests a number to be positive') do
    expect(1).to be_positive
  end

  it('tests article object') do
    # article = Article.create({title:'Sample title',content:"Sample content",slug:"sample-title"})
    # article = FactoryBot.create(:article)
    article = create(:article)
    expect(article.title).to eq('Sample article')
  end
end

require 'rails_helper'

RSpec.describe Article, type: :model do
  describe '#validations' do
    let(:article) { build(:article) }
    it('test that factory is valid') do
      # article = build(:article)
      expect(article).to be_valid # article.valid?==true
    end

    it('has an invalid title') do
      article.title = ''
      # article = build(:article, title: '')
      expect(article).not_to be_valid
      expect(article.errors[:title]).to include("can't be blank")
    end

    it('validates for invalid  slug') do
      article.slug = ''
      expect(article).not_to be_valid
      expect(article.errors[:slug]).to include("can't be blank")
    end

    it('validates the content has to be presense') do
      article.content = ''
      expect(article).not_to be_valid
      expect(article.errors[:content]).to include("can't be blank")
    end

    it('gets the slug id') do
      expect(article.slug).to eq('sample-article')
    end

    describe '.recent' do
      it('returns articles in the correct order ') do
        older_article = create(:article, created_at: 1.hour.ago)
        recent_article = create(:article)

        expect(described_class.recent).to eq([recent_article, older_article])

        recent_article.update_column(:created_at, 2.hours.ago)

        expect(described_class.recent).to eq([older_article, recent_article])
      end
    end
  end
end

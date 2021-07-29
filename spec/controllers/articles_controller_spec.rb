require 'rails_helper'

describe ArticlesController do
  describe '#index' do
    # subject { get :index }
    subject { get :index }
    it('should return a success response') do
      subject
      # get('/articles')
      # expect(response.status).to eq(200)
      expect(response).to have_http_status(:ok)
    end

    it('returns a proper JSON') do
      article = create :article
      # get '/articles'
      subject
      expect(json_data.length).to eq(1)
      expected = json_data.first
      aggregate_failures do
        expect(expected[:id]).to eq(article.id.to_s)
        expect(expected[:type]).to eq('article')
        expect(expected[:attributes]).to eq(
          title: article.title,
          content: article.content,
          slug: article.slug
        )
      end
    end

    it 'returns articles in the proper order' do
      older_article =
        create(:article, created_at: 1.hour.ago)
      recent_article = create(:article)
      #   get '/articles'
      subject
      ids = json_data.map { |item| item[:id].to_i }
      expect(ids).to(
        eq([recent_article.id, older_article.id])
      )
    end

    it('paginates results') do
      article1, article2, article3 = create_list(:article, 3)
      #   get '/articles', params: { page: { number: 2, size: 1 } }
      get :index, params: { page: { number: 2, size: 1 } }
      expect(json_data.length).to eq(1)
      expect(json_data.first[:id]).to eq(article2.id.to_s)
    end

    it('paginates results') do
      article1, article2, article3 = create_list(:article, 3)
      #   get '/articles', params: { page: { number: 2, size: 1 } }
      get :index, params: { page: { number: 2, size: 1 } }
      expect(json[:links].length).to eq(5)
      expect(json[:links].keys).to contain_exactly(:first, :prev, :next, :last, :self)
    end

    describe '#show' do
      let(:article) { create :article }
      subject { get :show, params: { id: article.id } }
      #   subject { get "/articles/#{article.id}" }
      #   subject { get :show, params { id: article.id } }

      #   before { subject }

      it 'returns a success response' do
        subject
        expect(response).to have_http_status(:ok)
      end

      it 'returns a proper JSON' do
        subject
        # subject { get "/articles/#{article.id}" }
        aggregate_failures do
          expect(json_data[:id]).to eq(article.id.to_s)
          expect(json_data[:type]).to eq('article')
          expect(json_data[:attributes]).to eq({
                                                 title: article.title,
                                                 content: article.content,
                                                 slug: article.slug
                                               })
        end
      end

      describe '#create' do
        subject { post :create }

        context 'when no code provided' do
          it_behaves_like 'forbidden_requests'
        end

        context 'when invalid code provided' do
          before { request.headers['authorization'] = 'Invalid token' }
          it_behaves_like 'forbidden_requests'
        end

        context 'when authorized' do
          let(:access_token) { create :access_token }
          before { request.headers['authorization'] = "Bearer #{access_token.token}" }

          context 'when invalid parameters provided' do
            let(:invalid_attributes) do
              {
                data: {
                  attributes: {
                    'title' => '',
                    'content' => '',
                    'slug' => ''
                  }
                }
              }
            end

            subject { post :create, params: invalid_attributes }

            it 'should return 422 status code' do
              subject
              expect(response).to have_http_status(:unprocessable_entity)
            end

            it 'should return proper error json' do
              subject

              data = JSON.parse(response.body)
              # pp data
              # pp data
              # pp data['errors']

              # pp response.body
              # pp JSON.parse(response.body)
              # pp subject
              # pp json[:errors]
              expect(data).to include(invalid_attributes[:data][:attributes])
              # {

              #   'source' => { 'pointer' => '/data/attributes/title' },
              #   'detail' => "can't be blank"
              # },
              # {

              #   'source' => { 'pointer' => '/data/attributes/content' },
              #   'detail' => "can't be blank"
              # },
              # {

              #   'source' => { 'pointer' => '/data/attributes/slug' },
              #   'detail' => "can't be blank"
              # }
              # expect(json[:errors]).to eq(nil)
            end
          end

          context 'when sucess request sent' do
            let(:access_token) { create :access_token }
            before { request.headers['authorization'] = "Bearer #{access_token.token}" }

            let(:valid_attributes) do
              {
                data: {
                  attributes: {
                    'title' => 'Awesome Article',
                    'content' => 'Super content',
                    'slug' => 'awesome-article'
                  }
                }
              }
            end

            subject { post :create, params: valid_attributes }

            it 'should have 201 status code' do
              subject
              expect(response).to have_http_status(:created)
            end

            it 'should have a proper json body' do
              subject
              # pp subject

              data = JSON.parse(response.body)
              # pp data

              expect(data).to include(valid_attributes[:data][:attributes])
            end

            it 'should create the article' do
              expect { subject }.to change { Article.count }.by(1)
            end
          end
        end
      end

      describe '#update' do
        let(:article) { create :article }

        subject { patch :update, params: { id: article.id } }

        context 'when no code provided' do
          it_behaves_like 'forbidden_requests'
        end

        context 'when invalid code provided' do
          before { request.headers['authorization'] = 'Invalid token' }
          it_behaves_like 'forbidden_requests'
        end

        context 'when authorized' do
          let(:access_token) { create :access_token }
          before { request.headers['authorization'] = "Bearer #{access_token.token}" }

          context 'when invalid parameters provided' do
            let(:invalid_attributes) do
              {
                data: {
                  attributes: {
                    'title' => '',
                    'content' => ''
                  }
                }
              }
            end

            subject do
              patch :update, params: invalid_attributes.merge(id: article.id)

              it 'should return 422 status code' do
                subject
                expect(response).to have_http_status(:unprocessable_entity)
              end

              it 'should return proper error json' do
                subject

                data = JSON.parse(response.body)
                # pp data

                expect(data).to include(invalid_attributes[:data][:attributes])
              end
            end

            context 'when sucess request sent' do
              let(:access_token) { create :access_token }
              before { request.headers['authorization'] = "Bearer #{access_token.token}" }

              let(:valid_attributes) do
                {
                  data: {
                    attributes: {
                      'title' => 'Awesome Article',
                      'content' => 'Super content',
                      'slug' => 'awesome-article'
                    }
                  }
                }
              end

              subject do
                patch :update, params: valid_attributes.merge(id: article.id)
              end

              it 'should have 200 status code' do
                subject
                expect(response).to have_http_status(:ok)
              end

              it 'should have a proper json body' do
                subject
                # pp subject

                data = JSON.parse(response.body)
                # pp data

                expect(data).to include(valid_attributes[:data][:attributes])
              end

              it 'should update the article' do
                subject
                data = JSON.parse(response.body)
                pp data
                expect(data[:title]).to eq(valid_attributes[:data][:attributes][:title])
              end
            end
          end
        end
      end
    end
  end
end

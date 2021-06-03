require 'rails_helper'

RSpec.describe AccessTokenController, type: :controller do
  describe '#create' do
    context 'when inalid request' do
      let(:error) do
        {
          status: '401',
          source: { pointer: '/code' },
          title: 'Authentication code is invalid',
          detail: 'You must provide a valid code in order to exchange it for token'
        }

        # {
        #   'status' => '401',
        #   'source' => { 'pointer' => '/code' },
        #   'title' => 'Authentication code is invalid',
        #   'detail' => 'You must provide a valid code in order to exchange it for token'
        # }
      end

      it('should return 401 status code') do
        post :create
        expect(response).to have_http_status(401)
      end

      it('should return proper error body') do
        post :create
        expect(json[:errors]).to include(error)
      end
    end

    context 'when success request' do
    end
  end
end
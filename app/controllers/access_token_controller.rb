class AccessTokenController < ApplicationController
  def create
    authenticator = UserAuthenticator.new(params[:code])
    begin authenticator.perform
    rescue UserAuthenticator::AuthenticationError
      error =
        {
          status: '401',
          source: { pointer: '/code' },
          title: 'Authentication code is invalid',
          detail: 'You must provide a valid code in order to exchange it for token'
        }

      render json: { "errors": [error] }, status: 401
    end
  end
end

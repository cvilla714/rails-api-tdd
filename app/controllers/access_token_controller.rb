class AccessTokenController < ApplicationController
  rescue_from UserAuthenticator::AuthenticationError, with: :authentication_error

  def create
    authenticator = UserAuthenticator.new(params[:code])
    authenticator.perform
  end

  private

  def authentication_error
    error =
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

    render json: { "errors": [error] }, status: 401
  end
end

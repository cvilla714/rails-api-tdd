class AccessTokenController < ApplicationController
  def create
    authenticator = UserAuthenticator.new(params[:code])
    authenticator.perform

    # render json: {}, status: :created
    # render json: authenticator.access_token, status: :created
    render json: AccessTokenSerializer.new(authenticator.access_token), status: :created
  end

  def destroy
    raise AuthorizationError
  end
end

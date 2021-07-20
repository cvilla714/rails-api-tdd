class AccessTokenController < ApplicationController
  skip_before_action :authorize!, only: :create

  def create
    authenticator = UserAuthenticator.new(params[:code])
    authenticator.perform

    # render json: {}, status: :created
    # render json: authenticator.access_token, status: :created
    render json: AccessTokenSerializer.new(authenticator.access_token), status: :created
  end

  def destroy
    # provided_token = request.authorization
    # pp provided_token
    # provided_token = request.authorization&.gsub(/\ABearer\s/, '')
    # pp provided_token

    # access_token = AccessToken.find_by(token: provided_token)
    # pp access_token

    # current_user = access_token&.user
    # pp current_user

    # raise AuthorizationError unless current_user

    current_user.access_token.destroy
  end
end

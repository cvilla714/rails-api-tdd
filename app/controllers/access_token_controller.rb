class AccessTokenController < ApplicationController
  def create
    authenticator = UserAuthenticator.new(params[:code])
    authenticator.perform

    render json: {}, status: :created
  end
end

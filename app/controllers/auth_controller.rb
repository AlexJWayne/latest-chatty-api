class AuthController < ApplicationController
  def create
    if params[:username] && params[:password]
      @success = LoginCookie.new(params[:username], params[:password]).success?
      render :status => :forbidden unless @success
    else
      authenticate_or_request_with_http_basic do |username, password|
        @success = LoginCookie.new(username, password).success?
      end
    end
  end

end

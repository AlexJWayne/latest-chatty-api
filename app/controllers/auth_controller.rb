class AuthController < ApplicationController
  def create
    @success = LoginCookie.new(params[:username], params[:password]).success?
    
    if @success
      render
    else
      render :status => :forbidden
    end
  end

end

class MessagesController < ApplicationController
  before_filter :auth
  
  def index
    @messages = Message.fetch(@username, @password)
  end
  
  def update
    @response = Message.read(@username, @password, params[:id])
  end
  
  protected
    def auth
      authenticate_or_request_with_http_basic do |username, password|
        @username = username
        @password = password
        LoginCookie.new(username, password).success?
      end
    end
    
end

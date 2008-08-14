class MessagesController < ApplicationController
  
  def index
    authenticate_or_request_with_http_basic do |username, password|
      @username = username
      @messages = Message.fetch(username, password)
      if @messages == :not_authorized
        render :text => '<error>Authentication Failed</error>', :status => response.status
      else
        true
      end
    end
  end
  
  def read
    authenticate_or_request_with_http_basic do |username, password|
      response = Message.read(username, password, params[:id])
      if @messages == :not_authorized
        render :text => '<error>Authentication Failed</error>', :status => response.status
      else
        render :text => '<error>Success</error>'
      end
    end
  end
    
end

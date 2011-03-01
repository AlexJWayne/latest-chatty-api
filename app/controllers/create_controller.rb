class CreateController < ApplicationController
  
  def index
    username, password = params[:username], params[:password]
    response_text = nil
    
    if username && password
      response_text = post username, password
    else
      authenticate_or_request_with_http_basic do |username, password|
        response_text = post username, password
      end
    end
    
    render :text => response_text
  end
  
  private
  
  def post(username, password)
    NewApi.create_post username, password, params[:body], :parent_id => params[:id], :story_id => params[:story_id]
  end
  
end

class CreateController < ApplicationController
  
  def index
    username, password = params[:username], params[:password]
    
    authenticate_or_request_with_http_basic do |username, password|
      if @success = LoginCookie.new(username, password).success?
        response = Post.create(params[:body], {
          :username   => username,
          :password   => password,
          :parent_id  => params[:id],
          :story_id   => params[:story_id]
        })
        
        render :status => :created
      else
        false
      end
    end
  end
  
end

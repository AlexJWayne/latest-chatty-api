class CreateController < ApplicationController
  
  def index
    login_url = "http://www.shacknews.com/login_laryn.x"
    response = Post.create(params[:body], {
      :username   => params[:username],
      :password   => params[:password],
      :parent_id  => params[:id],
      :story_id   => params[:story_id]
    })
    
    if response == :not_authorized
      render :text => '<error>Authentication failed</error>', :status => '403 Forbidden', :content_type => 'text/xml'
    else
      render :text => '<success>Comment posted</success>', :status => '201 Created', :content_type => 'text/xml'
    end
  end
  
end

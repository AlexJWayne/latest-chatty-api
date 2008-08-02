class CreateController < ApplicationController
  
  def index
    login_url = "http://www.shacknews.com/login_laryn.x"
    response = Post.create(params[:body], {
      :username   => params[:username],
      :password   => params[:password],
      :parent_id  => params[:id],
      :story_id   => params[:story_id]
    })
    
    render :text => 'Comment posted'
  end
  
end

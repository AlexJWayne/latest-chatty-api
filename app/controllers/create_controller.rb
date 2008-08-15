class CreateController < ApplicationController
  
  def index
    login_url = "http://www.shacknews.com/login_laryn.x"
    status = Post.create(params[:body], {
      :username   => params[:username],
      :password   => params[:password],
      :parent_id  => params[:id],
      :story_id   => params[:story_id]
    })
    
    case status
    when :created
      render_status status, 'Comment posted'
    when :not_authorized
      render_status status, 'Authentication failed'
    when :not_acceptable
      render_status status, 'Post rate limited, try again in a few minutes'
    end
  end
  
  protected
    def render_status(status, message)
      message = status == :created ? "<success>#{message}</success>" : "<error>#{message}</error>"
      render :text => message, :status => status, :content_type => 'text/xml'
    end
  
end

class ParseController < ApplicationController
  # def full
  #   @feed = Feed.new(:story_id => params[:id])
  #   render :action => 'index'
  # end
  
  def index
    Feed.work_safe = request.subdomains.include?('ws')
    @feed = Feed.new(:story_id => params[:id], :page => params[:page], :parse_children => false)
  end
  
  def thread
    return render(:text => 'Thread too big!') if params[:id].to_s == '22004750'
    
    @feed = Feed.new(:root_id => params[:id], :parse_children => true)
    
    if @feed.posts.empty?
      page = Downloader.parse_url("http://www.shacknews.com/laryn.x?id=#{params[:id]}")
      
      if root_node = page.find_first('//div[@class="root"]')
        root_id = root_node[:id].gsub('root_', '').to_i
        @feed = Feed.new(:root_id => root_id, :parse_children => true)
      else
        no_post = Post.new(nil)
        no_post.preview = 'Post not found...'
        no_post.body = 'Post not found...'
        @feed.posts << no_post
      end
    end
    
    render :action => 'index'
  end
  
  def push
    # Delayed::Job.enqueue Device::PushPerformer.new
    # render :text => 'Push Began...'
  end
end

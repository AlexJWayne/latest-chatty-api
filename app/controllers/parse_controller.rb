class ParseController < ApplicationController
  # def full
  #   @feed = Feed.new(:story_id => params[:id])
  #   render :action => 'index'
  # end
  
  def index
    # Feed.work_safe = request.subdomains.include?('ws')
    # @feed = Feed.new(:story_id => params[:id], :page => params[:page], :parse_children => false)
    
    chatty = NewApi.chatty['data']
    render :json => {
      :page       => '1',
      :last_page  => chatty['page_count'],
      :story_name => '(No story support in API)',
      :story_id   => '1',
      :comments   => convert_comments(chatty['comments'])
    }.to_json
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
  
private
  def convert_comments(comments)
    comments.map do |comment|
      comment['category']       = comment['mod_type']
      comment['date']           = comment['post_time']
      comment['author']         = comment['user']
      comment['reply_count']    = comment['post_count']
      comment['last_reply_id']  = comment['last_id']
      comment['comments']       = comment['comments'] ? convert_comments(comment['comments']) : []
      comment
    end
  end
  
end

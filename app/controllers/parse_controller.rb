class ParseController < ApplicationController
  # def full
  #   @feed = Feed.new(:story_id => params[:id])
  #   render :action => 'index'
  # end
  
  def index
    chatty = NewApi.chatty(params[:id] || 'index', :page => params[:page])['data']
    render :json => {
      :page       => chatty['page'],
      :last_page  => chatty['page_count'],
      :story_name => chatty['title'],
      :story_id   => 'index',
      :comments   => convert_comments(chatty['comments'])
    }.to_json
    
    # Feed.work_safe = request.subdomains.include?('ws')
    # @feed = Feed.new(:story_id => params[:id], :page => params[:page], :parse_children => false)
  end
  
  def thread
    chatty = NewApi.thread(params[:id])['data']
    render :json => {
      :page       => '1',
      :last_page  => chatty['page_count'],
      :story_name => chatty['title'],
      :story_id   => '1',
      :comments   => convert_comments(chatty['comments'])
    }.to_json
    
    # return render(:text => 'Thread too big!') if params[:id].to_s == '22004750'
    # 
    # @feed = Feed.new(:root_id => params[:id], :parse_children => true)
    # 
    # if @feed.posts.empty?
    #   page = Downloader.parse_url("http://www.shacknews.com/laryn.x?id=#{params[:id]}")
    #   
    #   if root_node = page.find_first('//div[@class="root"]')
    #     root_id = root_node[:id].gsub('root_', '').to_i
    #     @feed = Feed.new(:root_id => root_id, :parse_children => true)
    #   else
    #     no_post = Post.new(nil)
    #     no_post.preview = 'Post not found...'
    #     no_post.body = 'Post not found...'
    #     @feed.posts << no_post
    #   end
    # end
    # 
    # render :action => 'index'
  end
  
  def push
    # Delayed::Job.enqueue Device::PushPerformer.new
    # render :text => 'Push Began...'
  end
  
private
  def convert_comments(comments)
    comments.map do |comment|
      comment['category']       = comment['mod_type']
      comment['date']           = Time.parse(comment['post_time'])
      comment['author']         = comment['user']
      comment['reply_count']    = comment['post_count']
      comment['last_reply_id']  = comment['last_id']
      comment['body']           = CGI.unescapeHTML(comment['body']).gsub("return doSpoiler( event )", "this.className = ''")
      comment['preview']        = CGI.unescapeHTML(comment['preview'])
      comment['comments']       = comment['comments'] ? convert_comments(comment['comments']) : []
      
      comment['body'] = "This API is dead, please change your API server in the app settings to:<br/><br/><pre class='jt_code'>shackapi.stonedonkey.com</pre>"
      
      comment
    end
  end
  
end

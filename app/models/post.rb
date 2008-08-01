class Post
  attr_accessor :id, :author, :date, :preview, :body, :children, :parent, :category
  
  def initialize(xml, options = {})
    # setup an empty array for sollecting child posts
    @children = []
  
    # Save the parent post
    @parent = options[:parent]
    
    # Find the id of this post.
    @id = (is_root?(xml) ? (xml / 'li[@id]').first[:id] : xml[:id]).gsub('item_', '').to_i
    
    post_content_feed = options[:post_content_feed]
    if options[:parse_children]
      # Get the content for a thread.  This should only be done for the root post.
      post_content_feed ||= Hpricot(open("http://www.shacknews.com/frame_laryn.x?root=#{@id}"))
    end
    
    # Parse the main feed.
    
    # Root post
    if is_root?(xml)
      @author = (xml / 'span.author a').first.inner_html.strip
      @date   = (xml / 'div.postdate').first.inner_html.strip
      @body   = (xml / 'div.postbody').first.inner_html.strip
      
      @preview = @body.gsub(/<.+?>/, '')[0..100]
      
      child_selector = 'div.capcontainer>ul>li'
    
    # Child post
    else
      @author = (xml / 'a.oneline_user').first.inner_html.strip
      @date   = (post_content_feed / "div#item_#{@id} div.postdate").first.inner_html.strip
      @body   = (post_content_feed / "div#item_#{@id} div.postbody").first.inner_html.strip
      @preview = (xml / 'span.oneline_body').first.inner_html.strip.gsub(/<.+?>/, '')
      
      child_selector = '>ul>li'
    end
    
    # Convert spoiler javascript to something simpler
    @body = @body.gsub('doSpoiler( event )', 'doSpolier(this)')
    
    if options[:parse_children]
      # Create child posts
      (xml / child_selector).each do |child_post|
        @children << Post.new(child_post, :parent => self, :post_content_feed => post_content_feed, :parse_children => options[:parse_children])
      end
    end
  end
  
  private
    def is_root?(xml)
      (xml / 'div.postbody').any?
    end
    
    def bench(name)
      start = Time.now
      yield
      puts "=== Benchmark:#{name}: #{Time.now - start}"
    end
end
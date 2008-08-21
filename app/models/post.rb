class Post
  attr_accessor :id, :author, :date, :preview, :body, :children, :parent, :category, :reply_count, :last_reply_id
  
  def self.create(body, options)
    username  = options[:username]
    password  = options[:password]
    parent_id = options[:parent_id]
    story_id  = options[:story_id]
    
    response = Net::HTTP.post_form URI.parse('http://www.shacknews.com/extras/post_laryn_iphone.x'), {
      :iuser  => username,
      :ipass  => password,
      :parent => parent_id,
      :group  => story_id,
      :dopost => 'dopost',
      :body   => body,
    }
    
    case response.body
    when /You must be logged in/
      :not_authorized
    else
      true
    end
    
  end
  
  def initialize(xml, options = {})
    # setup an empty array for collecting child posts
    @children = []
  
    # Save the parent post
    @parent = options[:parent]
    
    # Find the id of this post.
    @id = (is_root?(xml) ? xml.find_first('.//li[@id]').attributes[:id] : xml.attributes[:id]).gsub('item_', '').to_i
    
    post_content_feed = options[:post_content_feed]
    if options[:parse_children]
      # Get the content for a thread.  This should only be done for the root post.
      post_content_feed ||= begin
        parser = LibXML::XML::HTMLParser.new
        parser.string = bench('get feed') { open("http://www.shacknews.com/frame_laryn.x?root=#{@id}") }.read
        parser.parse.root
      end
    end
    
    # Parse the main feed.
    
    # Root post
    if is_root?(xml)
      @author = xml.find_first('.//span[contains(@class, "author")]/a').content.strip
      @date   = xml.find_first('.//div[contains(@class, "postdate")]').content.strip
      @body   = xml.find_first('.//div[contains(@class, "postbody")]').to_s.inner_html.strip
      @reply_count   = xml.find_first('.//p[contains(@class, "capnote")]/a/strong').to_s.inner_html.gsub('&#13;', '').strip.to_i
      
      if element = xml.find_first('.//div[contains(@class, "oneline0")]/a')
        @last_reply_id = element.attributes[:href].gsub('laryn.x?id=', '').to_i
      end
      
      cat_node       = xml.find_first('ul/li/div[contains(@class, "fpmod_")]')
      child_selector = './/div[contains(@class, "capcontainer")]/ul/li'
    
    # Child post
    else
      @author = xml.find_first('.//a[contains(@class, "oneline_user")]').content.strip
      @date   = post_content_feed.find_first("//div[@id='item_#{@id}']//div[contains(@class, 'postdate')]").content.strip
      @body   = post_content_feed.find_first(".//div[@id='item_#{@id}']//div[contains(@class, 'postbody')]").to_s.inner_html.strip
      @reply_count = xml.find('.//li').size
      
      cat_node       = xml.find_first('div[contains(@class, "olmod_")]')
      child_selector = 'ul/li'
    end
    
    # Prepare preview
    @preview = @body.dup
    @preview.gsub!('&#13;', ' ')                                    # remove line break entities
    @preview.gsub!(/<br.*?>/, ' ')                                  # remove <br />'s
    @preview.gsub!(/\s+/, ' ')                                      # remove consecutive spaces
    @preview.gsub!(/<span class="jt_spoiler".+?<\/span>/, '______') # remove spoilers
    @preview.gsub!(/<.+?>/, '')                                     # strip all html tags
    @preview = @preview[0..150]                                     # truncate to 150 character max
    
    # Grab category
    @category = cat_node.attributes[:class].split(' ').find { |cls| cls =~ /mod_/ }.gsub(/^(fp|ol)mod_/, '') if cat_node
    
    # Convert spoiler javascript to something simpler
    @body = @body.gsub("return doSpoiler( event )", "this.className = ''")
    
    if options[:parse_children]
      # Create child posts
      xml.find(child_selector).each do |child_post|
        post = Post.new(child_post, :parent => self, :post_content_feed => post_content_feed, :parse_children => options[:parse_children])
        @children << post unless post.category == 'nws' && Feed.work_safe
      end
    end
  end
  
  def to_hash
    {
      :id => @id,
      :author => @author,
      :date => @date,
      :preview => @preview,
      :body => @body,
      :reply_count => @reply_count,
      :last_reply_id => @last_reply_id,
      :category => @category,
      :comments => @children.collect(&:to_hash),
    }
  end
  
  def to_json
    to_hash.to_json
  end
  
  private
    def is_root?(xml)
      xml.find_first('ul/li/div/div[contains(@class, "postbody")]')
    end

end
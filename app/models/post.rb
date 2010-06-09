class Post
  attr_accessor :id, :root_id, :author, :date, :preview, :body, :children, :parent, :category, :reply_count, :last_reply_id, :story_name, :story_id, :participants
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

    # abort further setup if no XML was passed in
    return unless xml

    # Save the parent post
    @parent = options[:parent]

    @is_root = options[:is_root]

    # Find the id of this post.
    @id = (is_root?(xml) ? xml.find_first('.//li[@id]').attributes[:id] : xml.attributes[:id]).gsub('item_', '').to_i

    all_children = options[:all_children]
    post_content_feed = options[:post_content_feed]
    if options[:parse_children]
      # Get the content for a thread.  This should only be done for the root post.
      post_content_feed ||= Downloader.parse_url("http://www.shacknews.com/frame_laryn.x?root=#{@id}")
      all_children ||= get_all_children(post_content_feed)
    end

    # Parse the main feed.

    # Root post
    if is_root?(xml)
      @author = xml.find_first('.//span[contains(@class, "author")]/a').content.strip
      @date   = Time.parse(xml.find_first('.//div[contains(@class, "postdate")]').content.strip)
      @body   = xml.find_first('.//div[contains(@class, "postbody")]').to_s.inner_html.strip
      @reply_count   = xml.find_first('.//p[contains(@class, "capnote")]/a/strong').to_s.inner_html.gsub('&#13;', '').strip.to_i

      if element = xml.find_first('.//div[contains(@class, "oneline0")]/a')
        @last_reply_id = element.attributes[:href].gsub('laryn.x?id=', '').to_i
      end

      cat_node       = xml.find_first('ul/li/div[contains(@class, "fpmod_")]')
      child_selector = './/div[contains(@class, "capcontainer")]/ul/li'

      # Find particpants
      @participants = {}
      xml.find('.//a[contains(@class, "oneline_user")]').each do |author_link|
        username = author_link.to_s.inner_html.gsub('&#13;', '').strip
        @participants[username] ||= 0
        @participants[username] += 1
      end

    # Child post
    else
      @author = xml.find_first('.//a[contains(@class, "oneline_user")]').content.strip
      @my_post = all_children[@id]

      @date   = Time.parse(@my_post.find_first(".//div[contains(@class, 'postdate')]").content.strip) rescue nil
      @body   = @my_post.find_first(".//div[contains(@class, 'postbody')]").to_s.inner_html.strip rescue nil
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
    @preview = @preview[0..500]                                     # truncate to 500 character max

    # Grab category
    @category = cat_node.attributes[:class].split(' ').find { |cls| cls =~ /mod_/ }.gsub(/^(fp|ol)mod_/, '') if cat_node

    # Convert spoiler javascript to something simpler
    @body = @body.gsub("return doSpoiler( event )", "this.className = ''")

    if options[:parse_children]
      # Create child posts
      xml.find(child_selector).each do |child_post|
        post = Post.new(child_post, :parent => self, :post_content_feed => post_content_feed, :parse_children => options[:parse_children], :all_children=>all_children, :is_root=>false)
        @children << post unless post.category == 'nws' && Feed.work_safe
      end
    end
  end

  def to_hash
    attributes = {
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
    attributes[:story_id]     = @story_id     if @story_id
    attributes[:story_name]   = @story_name   if @story_name

    if @participants
      attributes[:participants] = @participants.map do |username, post_count|
        { :username => username, :post_count => post_count }
      end
    end

    attributes
  end

  def to_json(options = {})
    to_hash.to_json(options)
  end

  private
    def is_root?(xml)
      return @is_root unless @is_root.nil?
      @is_root = xml.find_first('ul/li/div/div[contains(@class, "postbody")]')
    end
    def get_all_children(post_content_feed)
      mapped_children = {}
      post_content_feed.find('.//div[contains(@id, "item_")]').each do |child|
        child_id = child.attributes["id"].to_s.gsub("item_", "").to_i
        mapped_children[child_id] = child
      end
      mapped_children
    end
end


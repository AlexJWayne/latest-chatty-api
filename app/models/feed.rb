class Feed
  cattr_accessor :work_safe
  attr_accessor :posts, :story_id, :story_name, :page, :last_page
  
  @@work_safe = false
  
  def initialize(options = {})
    @page = options[:page] || 1
    
    @last_page = 1
    
    # decide where to get the feed
    if options[:story_id]
      url = "http://www.shacknews.com/laryn.x?story=#{options[:story_id]}&page=#{@page}"
    elsif options[:root_id]
      url = "http://www.shacknews.com/frame_laryn.x?root=#{options[:root_id]}&id=#{options[:root_id]}&mode=refresh"
    else
      url = 'http://www.shacknews.com/latestchatty.x'
    end
    
    # Get root post content
    page = Downloader.parse_url(url)
    
    
    if options[:parse_children]
      # thread request, so we wont have the story data
      
      story_page = Downloader.get("http://www.shacknews.com/laryn.x?id=#{options[:root_id]}").clean_html
      story = Story.new
      story.parse_html(story_page)
      
      @story_id = story.id
      @story_name = story.name
    else
      
      story = page.find_first('.//div[contains(@class, "story")]//h1//a')
      unless @story_id = options[:story_id]
        @story_id = story[:href].gsub(/^.*onearticle\.x\//, '') if story
      end

      @story_name = story.content if story
    end    
    
    # get last page number
    if page.find_first('//div[contains(@class, "pagenavigation")]/a')
      @last_page = page.find('//div[contains(@class, "pagenavigation")]/a').find_all { |element| element.content =~ /\d+/ }.last.content.strip.to_i
    end
    
    # Parse posts
    @posts = []
    page.find('.//div[contains(@class, "root")]').each do |xml|
      post = Post.new(xml, :parent => nil, :parse_children => options[:parse_children])
      @posts << post unless post.category == 'nws' && Feed.work_safe
    end
  end
  
  def to_json
    {
      :story_id => @story_id,
      :story_name => @story_name,
      :page => @page,
      :last_page => @last_page,
      :comments => @posts.collect(&:to_hash)
    }.to_json
  end
end
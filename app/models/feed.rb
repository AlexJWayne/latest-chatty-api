class Feed
  attr_accessor :posts, :story_id
  
  def initialize(options = {})
    if options[:story_id]
      url = "http://www.shacknews.com/laryn.x?story=#{options[:story_id]}"
    elsif options[:root_id]
      url = "http://www.shacknews.com/frame_laryn.x?root=#{options[:root_id]}&id=#{options[:root_id]}&mode=refresh"
    else
      url = 'http://www.shacknews.com/latestchatty.x'
    end
    
    page = Hpricot(open(url))
    @posts = []
    
    @story_id = options[:story_id]
    if (page / 'div.story h1 a').any?
      @story_id = (page / 'div.story h1 a').first[:href].gsub('/onearticle.x/', '')
    end
    
    (page / 'div.root').each do |xml|
      @posts << Post.new(xml, :parent => nil, :parse_children => options[:parse_children])
    end
  end
end
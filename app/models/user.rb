class User
  attr_reader :name, :join_date, :age, :sex, :location, :homepage
  attr_reader :steam, :xbox_live, :psn, :wii, :xfire
  
  def initialize(username)
    @name = username
    
    # get user
    url = "http://www.shacknews.com/profile/#{username}"
    parser = LibXML::XML::HTMLParser.string(Downloader.get(url).clean_html, :options => HTML_PARSER_OPTIONS)
    page = parser.parse.root
    
    block_array = page.find('.//div[contains(@class, "thirdc")]')
    blocks = {}
    block_array.each do |b|
      h4 = b.find_first('.//h4')
      next unless h4
      
      name = b.find_first('.//h4').content.strip
      data = b.find('.//td').collect { |cell| cell.to_s.inner_html.strip.gsub('&#160;', '') }
      
      blocks[name] = data
    end
    
    # raise blocks['User Info'].inspect
    
    # user info block      
    @join_date = blocks['User Info'][0]
    @age       = blocks['User Info'][1]
    @sex       = blocks['User Info'][2]
    @location  = blocks['User Info'][3]
    @homepage  = blocks['User Info'][4].inner_html
    
    # gaming handles box
    @steam     = blocks['Gaming Handles'][0]
    @xbox_live = blocks['Gaming Handles'][1]
    @psn       = blocks['Gaming Handles'][2]
    @wii       = blocks['Gaming Handles'][3]
    @xfire     = blocks['Gaming Handles'][4]
  end
  
  def attributes
    {
      :name      => name,
      :join_date => join_date,
      :age       => age,
      :sex       => sex,
      :location  => location,
      :homepage  => homepage,
      
      :steam     => steam,
      :xbox_live => xbox_live,
      :psn       => psn,
      :wii       => wii,
      :xfire     => xfire,
    }
  end
  
  def to_xml(options = {})
    attributes.to_xml({ :root => :user }.merge(options))
  end
  
  def to_json(options = {})
    attributes.to_json options
    
  end
end
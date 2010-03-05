class User
  attr_reader :name, :join_date, :age, :sex, :location, :homepage
  attr_reader :steam, :xbox_live, :psn, :wii, :xfire
  
  def initialize(username)
    @name = username
    
    # get user
    url = "http://www.shacknews.com/profile/#{CGI.escape username}"
    page = Downloader.parse_url(url)
    
    block_array = page.find('.//div[contains(@class, "thirdc")]')
    blocks = {}
    block_array.each do |b|
      h4 = b.find_first('.//h4')
      next unless h4
      
      name = b.find_first('.//h4').content.strip
      data = b.find('.//td').collect { |cell| cell.to_s.inner_html.gsub('&#160;', ' ').strip }
      
      blocks[name] = data
    end
    
    if page.find_first('.//div[contains(@class, "profilemain")]').content.strip =~ /No such user/
      @name = "User not found"
    else
      # user info block
      @join_date = blocks['User Info'][0]
      @age       = blocks['User Info'][1]
      @sex       = blocks['User Info'][2]
      @location  = blocks['User Info'][3]
      @homepage  = blocks['User Info'][4].inner_html.strip
    
      # gaming handles box
      @steam     = blocks['Gaming Handles'][0].to_s.strip
      @xbox_live = blocks['Gaming Handles'][1].to_s.strip
      @psn       = blocks['Gaming Handles'][2].to_s.strip
      @wii       = blocks['Gaming Handles'][3].to_s.strip
      @xfire     = blocks['Gaming Handles'][4].to_s.strip
    end
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
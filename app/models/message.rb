class Message
  attr_reader :id, :from, :subject, :date, :body
  
  def self.fetch(username, password)
    response = PrivateRequest.new(username, password, 'http://www.shacknews.com/msgcenter/')
    
    parser = LibXML::XML::HTMLParser.new
    parser.string = response.body
    page = parser.parse.root
    
    messages = []
    
    returning [] do |messages|
      page.find('//table[@id="msgresults"]//tr').each do |row|
        next if row[:id] == 'msgfilters' || row[:class].include?('msgview_container')
        
        id = row.find_first('.//td[contains(@class, "subject")]')[:id].gsub('subject_', '').to_i
        
        messages << self.new({
          :id       => id,
          :from     => row.find_first('.//td[contains(@class, "shackname")]//a').content,
          :subject  => row.find_first('.//td[contains(@class, "subject")]//a').content,
          :date     => row.find_first('.//td[contains(@class, "date")]').content,
          :body     => page.find_first("//tr[@id='msgview_#{id}']//div[@id='msgcopy']").to_s.inner_html.strip,
        })
      end
    end
  end
  
  def initialize(options = {})
    @id   = options[:id]
    @from = options[:from]
    @subject = options[:subject]
    @date = options[:date]
    @body = options[:body]
  end
end
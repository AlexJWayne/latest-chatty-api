class Search
  def self.find(options)
    # Get a cookie
    cookie_url = 'http://www.shacknews.com/'
    uri = URI.parse(cookie_url)
    request = Net::HTTP::Get.new(uri.path)
    response = Net::HTTP.start(uri.host, uri.port) do |http|
      http.request request
    end
    cookie = response['set-cookie'].match(/shackon=.*?;/)[0]
    
    # Get the search results
    search_url = "http://www.shacknews.com/search.x?type=comments&terms=#{URI.escape options[:terms].to_s}&cs_user=#{URI.escape options[:author].to_s}&cs_parentauthor=#{URI.escape options[:parent_author].to_s}&s_type=all"
    uri = URI.parse(search_url)
    request = Net::HTTP::Get.new("#{uri.path}?#{uri.query}")
    request['Cookie'] = cookie
    
    response = Net::HTTP.start(uri.host, uri.port) do |http|
      http.request request
    end
    
    page = Downloader.parse_string(response.body.clean_html)
    
    posts = []
    page.find('//div[contains(@class, "interiorcontent")]//tr[@class]').each do |xml|
      post = Post.new(nil)
      post.id         = xml.find_first('.//td[contains(@class, "post")]/a').attributes['href'].match(/.*?(\d+)$/)[1].to_i
      post.author     = xml.find_first('.//td[contains(@class, "shackname")]//a').to_s.inner_html.strip
      post.preview    = xml.find_first('.//td[contains(@class, "post")]/a').to_s.inner_html.strip
      post.date       = xml.find_first('.//td[contains(@class, "date")]').to_s.inner_html.strip
      post.story_name = xml.find_first('.//td[contains(@class, "thread")]/a').to_s.inner_html.strip
      post.story_id   = xml.find_first('.//td[contains(@class, "thread")]/a').attributes['href'].match(/.*?(\d+)$/)[1].to_i
      posts << post
    end
    
    posts
  end
end
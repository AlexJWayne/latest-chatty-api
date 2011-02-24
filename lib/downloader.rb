require 'zlib'

# Supress non fatal parse errors
LibXML::XML::Error.set_handler(&LibXML::XML::Error::QUIET_HANDLER)

class Downloader
  HTML_PARSER_OPTIONS = LibXML::XML::HTMLParser::Options::RECOVER |
                        LibXML::XML::HTMLParser::Options::NOERROR |
                        LibXML::XML::HTMLParser::Options::NOWARNING
  
  def self.get(url)
    url = URI.parse(url)
    
    found = false
    until found
      host, port = url.host, url.port if url.host && url.port
      path = url.path
      path << "?#{url.query}" if url.query && url.query.any?
      
      req = Net::HTTP::Get.new(url.path, "Accept-Encoding" => "gzip")
      req['Cookie'] = LoginCookie.default.string
      res = Net::HTTP.start(url.host, url.port) { |http| http.request(req) }
      if res.header['location']
        location = res.header['location']
        location = "http://shacknews.com#{location}" if location =~ /^\//
        url = URI.parse(location)
      else
        found = true
      end
    end
    
    res.body
    # io = StringIO.new(res.body)
    # Zlib::GzipReader.new(io).read.clean_html
  end
  
  def self.parse_string(string)
    parser = LibXML::XML::HTMLParser.string(string, :options => HTML_PARSER_OPTIONS)
    parser.parse.root
  end
  
  def self.parse_url(url)
    parse_string(get(url))
  end
  
end
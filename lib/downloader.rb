require 'zlib'

class Downloader
  
  def self.get(url)
    url = URI.parse(url)
    
    found = false
    until found
      host, port = url.host, url.port if url.host && url.port
      path = url.path
      path << "?#{url.query}" if url.query && url.query.any?
      
      req = Net::HTTP::Get.new(url.path, "Accept-Encoding" => "gzip")
      res = Net::HTTP.start(url.host, url.port) { |http| http.request(req) }
      if res.header['location']
        url = URI.parse(res.header['location'])
      else
        found = true
      end
    end
        
    io = StringIO.new(res.body)
    Zlib::GzipReader.new(io).read
  end
  
end
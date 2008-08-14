class PrivateRequest
  attr_reader :response, :status
  
  def initialize(username, password, url, options = {})
    cookie = LoginCookie.new(username, password)
    
    if cookie.success?
      # Setup the request
      url = URI.parse(url)
      
      request = (options[:post] ? Net::HTTP::Post : Net::HTTP::Get).new(url.path)
      request['Cookie'] = cookie.string
      request.set_form_data options[:post] if options[:post]
    
      @response = Net::HTTP.new(url.host, url.port).start { |http| http.request(request) }
    else
      @status = cookie.status
    end
  end
  
  def method_missing(method, *args)
    @response.send(method, *args)
  end
end
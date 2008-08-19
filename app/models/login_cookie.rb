class LoginCookie
  attr_reader :string, :status
  
  def initialize(username, password)
    response = Net::HTTP.post_form(URI.parse('http://www.shacknews.com/login_laryn.x'), {
      :username => username,
      :password => password,
      :type     => 'login'
    })
    
    if pass_cookie = response.to_hash['set-cookie'].find { |cookie| cookie =~ /^pass=/ }
      encrypted_password = pass_cookie.match(/pass=([a-f0-9]+?);/)[1]
      
      @string = "user=#{username}; pass=#{encrypted_password}"
      @status = :success
    else
      @status = :not_authorized
    end
  end
  
  def success?
    @status == :success
  end
  
  
  
  class ShackPics < LoginCookie
    def initialize(username, password)
      response = `curl -i -d "user_name=#{username}&user_password=#{password}" http://www.shackpics.com/users.x?act=login_go`
      puts response
      
      if cookie = response.split("\n").find { |line| line =~ /^Set-Cookie: mmh_user_cookie=(.+?\.[A-Za-z0-9\.]+?);/ }
        cookie_value = $1
        
        @string = "mmh_user_cookie=#{cookie_value}"
        @status = :success
      else
        @status = :not_authorized
      end
    end
  end
end
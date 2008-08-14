class LoginCookie
  attr_reader :string, :status
  
  def initialize(username, password)
    # Post the login
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
end
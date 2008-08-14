class LoginCookie
  attr_reader :string
  
  def initialize(username, password)
    # Post the login
    response = Net::HTTP.post_form(URI.parse('http://www.shacknews.com/login_laryn.x'), {
      :username => username,
      :password => password,
      :type     => 'login'
    })
    
    if pass_cookie = response.to_hash['set-cookie'].find { |cookie| cookie =~ /^pass=/ }
      # Get the encrypted password form the response cookies
      encrypted_password = pass_cookie.match(/pass=([a-f0-9]+?);/)[1]
      
      # Create a cookie string to send back
      @string = "user=#{username}; pass=#{encrypted_password}"
    else
      :not_authorized
    end
  end
end
require 'base64'

class ImagesController < ApplicationController
  
  def create
    cookie = LoginCookie::ShackPics.new(params[:username], params[:password])
    if cookie.success?    
      extension = params[:filename].match(/\.(.+?)$/)[1]
      image_io  = StringIO.new(Base64.decode64(params[:image]))
      image_data = UploadIO.new(image_io, "image/#{extension}", params[:filename])
      
      url = URI.parse('http://shackpics.com/upload.x')
      request = Net::HTTP::Post::Multipart.new(url.path, "userfile[]" => image_data)
      request['Cookie'] = cookie.string
      response = Net::HTTP.start(url.host, url.port) { |http| http.request(request) }
      
      parser = LibXML::XML::HTMLParser.new
      parser.string = response.body
      page = parser.parse.root
      
      puts response.body
      
      render :text => "<success>#{page.find_first("//input[@id='link11']")[:value]}</success>", :status => :created
    else
      render :text => "<error>Not Authorized</error>", :status => :forbidden
    end
  end  
end
require 'digest/md5'
require 'httparty'

module NewApi
  include HTTParty
  base_uri 'http://shacknews.com/'
  basic_auth Settings.default_user[:username], Settings.default_user[:password]
  
  KEY = '7ee22b8493af1629a861c4d1b2c3ca87'
  SECRET = '671dc44907638e8a515c202fe476bfb1'
  
  def self.signature
    signature = Digest::MD5.hexdigest "key=#{KEY}&secret=#{SECRET}&time#{Time.now.to_i}"
  end
  
  def self.chatty(id = nil)
    id = 'index' if !id || id.blank?
    response = NewApi.get "/api/chat/#{id}.json",
                    :key => KEY,
                    :time => Time.now.to_i,
                    :signature => signature
    JSON.parse response.body
  end
  
  def self.thread(id)
    response = NewApi.get "/api/chat/thread/#{id}.json",
                    :key => KEY,
                    :time => Time.now.to_i,
                    :signature => signature
    JSON.parse response.body
  end
end
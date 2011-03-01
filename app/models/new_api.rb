require 'digest/md5'
require 'httparty'

module NewApi
  include HTTParty
  base_uri 'http://www.shacknews.com/'
  basic_auth Settings.default_user[:username], Settings.default_user[:password]
  
  # Charles Proxy
  # http_proxy 'localhost', 8888
  
  KEY       = '7ee22b8493af1629a861c4d1b2c3ca87'
  SECRET    = '671dc44907638e8a515c202fe476bfb1'
  CHATTY_ID = '17'
  
  def self.signature
    signature = Digest::MD5.hexdigest "key=#{KEY}&secret=#{SECRET}&time#{Time.now.to_i}"
  end
  
  def self.chatty(id = nil, options = {})
    id = 'index' if !id || id == '0' || id.blank?
    response = get(
      "/api/chat/#{id}.json",
      :query => {
        :page => options[:page] || '1',
        :key => KEY,
        :time => Time.now.to_i,
        :signature => signature
      }
    )
    JSON.parse response.body
  end
  
  def self.thread(id)
    response = get(
      "/api/chat/thread/#{id}.json",
      :query => {
        :key => KEY,
        :time => Time.now.to_i,
        :signature => signature
      }
    )
    JSON.parse response.body
  end
  
  def self.create_post(username, password, message, options = {})
    parent_id = options[:parent_id] || '0'
    story_id  = options[:story_id] || CHATTY_ID
    response = post(
      "/api/chat/create/#{story_id}.json",
      :basic_auth => {
        :username => username,
        :password => password,
      },
      :body => {
        :key => KEY,
        :time => Time.now.to_i,
        :signature => signature,
        :body => message,
        :parent_id => parent_id,
        :content_id => CHATTY_ID,
        :content_type_id => CHATTY_ID,
      }
    )
    
    response.body
  end
end
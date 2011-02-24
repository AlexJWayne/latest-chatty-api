require 'digest/md5'
require 'httparty'

class NewApi
  include HTTParty
  base_uri 'http://stage.shacknews.thismoment.com/'
  basic_auth 'SqueegyTBS', 'YBYsaia2'
  
  KEY = '7ee22b8493af1629a861c4d1b2c3ca87'
  SECRET = '671dc44907638e8a515c202fe476bfb1'

  # md5(‘key=96cec7f1a66b3628dc15355945ddea63&secret=628dc15355945&time=1297451120’)
  def signature
    signature = Digest::MD5.hexdigest "key=#{KEY}&secret=#{SECRET}&time#{Time.now.to_i}"
  end
  
  def chatty
    response = NewApi.get '/api/chat/index.json',
                    :key => KEY,
                    :time => Time.now.to_i,
                    :signature => signature
    JSON.parse response.body
  end
end
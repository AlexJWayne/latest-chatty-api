# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  filter_parameter_logging :password, :image
  after_filter OutputCompressionFilter
  after_filter :check_push
  
  protected
    def auth
      authenticate_or_request_with_http_basic do |username, password|
        @username = username
        @password = password
        LoginCookie.new(username, password).success?
      end
    end
    
    def check_push
      # if Settings.last_push < 5.minutes.ago
      #   Delayed::Job.enqueue Device::PushPerformer.new
      # end
    end
end

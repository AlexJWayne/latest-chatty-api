# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  filter_parameter_logging :password, :image
  session :off
  after_filter OutputCompressionFilter
  
  protected
    def auth
      authenticate_or_request_with_http_basic do |username, password|
        @username = username
        @password = password
        LoginCookie.new(username, password).success?
      end
    end
end

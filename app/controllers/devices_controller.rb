class DevicesController < ApplicationController
  def create
    @device = Device.find_or_initialize_by_token(params[:token])
    @device.username = params[:username]
    @device.password = params[:password]
    @device.updated_at = Time.now
    @device.save
    
    render :text => 'Registered Device for Push'
  end
  
end

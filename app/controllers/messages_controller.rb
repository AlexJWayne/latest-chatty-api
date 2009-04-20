class MessagesController < ApplicationController
  before_filter :auth
  
  def index
    @messages = Message.fetch(@username, @password)
  end
  
  def update
    @response = Message.read(@username, @password, params[:id])
    render :text => "Message ##{params[:id]} read", :status => '200 OK'
  end
  
  def create
    @response = Message.create(@username, @password, {
      :to => params[:to],
      :subject => params[:subject],
      :body => params[:body]
    })    
    render :text => "Message Sent!", :status => '201 Created'
  end    
end

class ParseController < ApplicationController
  # def full
  #   @feed = Feed.new(:story_id => params[:id])
  #   render :action => 'index'
  # end
  
  def index
    @feed = RootList.new(:story_id => params[:id])
  end
  
  def thread
    @feed = Feed.new(:root_id => params[:id])
    render :action => 'index'
  end
end

class ParseController < ApplicationController
  # def full
  #   @feed = Feed.new(:story_id => params[:id])
  #   render :action => 'index'
  # end
  
  def index
    @feed = Feed.new(:story_id => params[:id], :parse_children => false)
  end
  
  def thread
    @feed = Feed.new(:root_id => params[:id], :parse_children => true)
    render :action => 'index'
  end
end

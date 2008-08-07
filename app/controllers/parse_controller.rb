class ParseController < ApplicationController
  # def full
  #   @feed = Feed.new(:story_id => params[:id])
  #   render :action => 'index'
  # end
  
  def index
    Feed.work_safe = request.subdomains.include?('ws')
    @feed = Feed.new(:story_id => params[:id], :page => params[:page], :parse_children => false)
  end
  
  def thread
    bench "overall" do
      @feed = Feed.new(:root_id => params[:id], :parse_children => true)
    end
    render :action => 'index'
  end
end

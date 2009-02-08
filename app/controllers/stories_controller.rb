class StoriesController < ApplicationController
  def index
    @stories = Story.all
  end
  
  def show
    @story = Story.new(params[:id])
  end
end

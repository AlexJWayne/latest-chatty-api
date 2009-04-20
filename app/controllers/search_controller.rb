class SearchController < ApplicationController
  def index
    @posts = Search.find(:terms => params[:terms], :author => params[:author], :parent_author => params[:parent_author])
  end

end

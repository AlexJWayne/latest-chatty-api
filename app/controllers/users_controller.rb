class UsersController < ApplicationController
  
  def show
    @user = User.new(params[:id])
  end

end

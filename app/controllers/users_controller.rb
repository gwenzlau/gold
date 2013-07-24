class UsersController < ApplicationController
  def index
	@users = User.order("created_at DESC")
	render :json => @users
	end

  def show
  	@user = User.find(params[:id])
  	#@post = @user.posts
  end
end

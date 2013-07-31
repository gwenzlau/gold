class UsersController < ApplicationController
	respond_to :json, :xml

  respond_to :json, :xml
  def index
  	@users = User.all
  end
end

  def show
  	@user = User.find(params[:id])
  	#@post = @user.posts.all

  end

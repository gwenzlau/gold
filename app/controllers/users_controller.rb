class UsersController < ApplicationController
	respond_to :json, :xml

  #respond_to :json, :xml
  def index
  	#render :json => @users
  	@users = User.order("created_at DESC")
  end

  def show
  	@user = User.find(params[:id])
    @posts = @user.posts.page
    #respond_to do |format|
     # format.html.fromat.json {render json: @user}

  # end
 end
end

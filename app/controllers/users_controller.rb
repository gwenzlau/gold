class UsersController < ApplicationController
	#respond_to :json, :xml

  def index
  	#render :json => @users
  	@users = User.order("created_at desc")

    respond_to do |format|
      format.html
      fromat.json {render json: @users}
    end
  end

  def show
  	@user = User.find(params[:id])

    @post = Post.where(:user_id => params[:id])
 end
end

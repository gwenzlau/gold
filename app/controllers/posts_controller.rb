class PostsController < ApplicationController
  respond_to :json, :xml
  
  before_action :authenticate_user!
#	skip_before_filter :verify_authenticity_token, :only => :create

	def index
   #lat, lng = params[:lat], params[:lng]
    #if lat and lng
      @posts = Post.order ("created_at DESC")
      render :json => @posts
      #.nearby(lat.to_f, lng.to_f)
     # respond_with({:posts => @posts})
    #respond_to do |format|
     # format.html
      #format.json #{render json: @post }
   # end
   
    #else
     # respond_with({:message => "Invalid or missing lat/lng params"}, :status => 406)
    #end
		

    #@posts = Post.order("created_at DESC")
		#render :json => @posts
	end

  def new
    @post = current_user.posts.new

    respond_to do |format|
      format.html
      format.json {render json: @post }
    end
  end


	def create
    @post = current_user.posts.new(post_params)
    if @post.save
      redirect_to current_user
     # render :json => {
      #  :success => true,
      #  :post => @post
      #}
    else
      render :json => {
        :success => false,
        :errors => @post.errors
      }
    end
  end

  def show
    @post = Post.find(params[:id])
    respond_to do |format|
      format.html
      format.json {render json: @post }
    end
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url}
      format.json { head :no_content }
    end
  end

  private
    
  def post_params
    params.require(:post).permit(:content, :lat, :lng, :photo, :submitted_by)
  end
end
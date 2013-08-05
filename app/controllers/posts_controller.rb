class PostsController < ApplicationController
  respond_to :json, :xml
#	skip_before_filter :verify_authenticity_token, :only => :create

	def index
   #lat, lng = params[:lat], params[:lng]
    #if lat and lng
      @posts = Post.order("created_at DESC")
      #.nearby(lat.to_f, lng.to_f)
      #respond_with({:posts => @posts})
   # respond_to do |format|
    #  format.html
     # format.json #{render json: @post }
    @end
   
    #else
     # respond_with({:message => "Invalid or missing lat/lng params"}, :status => 406)
    #end
		

    #@posts = Post.order("created_at DESC")
		#render :json => @posts
	end

	def create
    @post = Post.new(params[:post])
    if @post.save
      render :json => {
        :success => true,
        :post => @post
      }
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

end
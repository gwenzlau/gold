class PostsController < ApplicationController
	skip_before_filter :verify_authenticity_token, :only => :create

	def index
		@posts = Post.order("created_at DESC")
		render :json => @posts
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
end
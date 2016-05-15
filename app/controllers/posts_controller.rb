class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  def index
    @post = Post.all
  end
  
  def show
  end
  
  def new
    @post = Post.new
  end
  
  def create
    @post = Post.new(post_params)
    if @post.save
      flash[:success] = "Post has been saved"
      redirect_to posts_path
    else
      flash[:danger]= "Error! Post has not been saved"
      redirect_to :new
    end
  end
  
  def update
    if @post.update(post_params)
      flash[:success] = "Post has been successfully updated."
      redirect_to posts_path
    else
      flash[:danger] = "Error! Post has not been updated."
    end
  end
  
  def edit
  end
  
  def destroy
    @post.destroy
    flash[:danger] = "Post has been deleted"
    redirect_to posts_path
  end
  
  private
    def set_post
      @post = Post.find(params[:id])
    end
    def post_params
      params.require(:post).permit(:review)
    end
end

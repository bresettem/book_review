class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_review, only: [:show, :edit, :update, :destroy]
  before_action :owned_review, only: [:edit, :update, :destroy]
  def index
    @review = Review.all
  end
  
  def show
  end
  
  def new
    @review = current_user.reviews.build
    
  end
  
  def create
   @review = current_user.reviews.build(review_params)
    if @review.save
      flash[:success] = "Review has been saved"
      redirect_to reviews_path
    else
      flash[:danger]= "Error! Review has not been saved"
      render :new
    end
  end
  
  def update
    if @review.update(review_params)
      flash[:success] = "Review has been successfully updated."
      redirect_to reviews_path
    else
      flash[:danger] = "Error! Review has not been updated."
      render :edit
    end
  end
  
  def edit
  end
  
  def destroy
    @review.destroy
    flash[:danger] = "Review has been deleted"
    redirect_to reviews_path
  end
  
  private
    def set_review
      @review = Review.find(params[:id])
    end
    
    def review_params
      params.require(:review).permit(:review)
    end
    
    def owned_review
      unless current_user == @review.user
        flash[:danger] = "Error! The review doesn't belong to you."
        redirect_to reviews_path
      end
    end
end

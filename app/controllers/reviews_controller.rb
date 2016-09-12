class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_book
  before_action :set_review, only: [:show, :edit, :update, :destroy]
  before_action :set_book_review, only: [:edit, :update, :destroy]
  before_action :owned_review, only: [:edit, :update, :destroy]
  
  def index
    @reviews = @book.reviews.paginate(:page => params[:page], :per_page => 30).order('created_at DESC')
  end
  
  def new
    @review = @book.reviews.build
  end
  
  def create
   @review = @book.reviews.build(review_params)
   @review.user_id = current_user.id
   
    if @review.save
      flash[:success] = "Review has been saved"
      redirect_to book_path(@book)
    else
      flash[:danger]= "Error! Review has not been saved"
      redirect_to book_path(@book)
    end
  end
  
  def edit
  end
  
  def update
    if @review.update(review_params)
      flash[:success] = "Review has been successfully updated."
      redirect_to book_path(@book)
    else
      flash[:danger] = "Error! Review has not been updated."
      render :edit
    end
  end
  
  def destroy
    @review.destroy
    flash.now[:danger] = "Review has been deleted"
    #redirect_to book_reviews_path
    redirect_to book_path(@book)
  end
  
  private
    def set_review
      @review = Review.find(params[:id])
    end
    
    def set_book_review
      @review = @book.reviews.find(params[:id])
    end
    
    def load_book
      @book = Book.find(params[:book_id])
    end
    
    def review_params
      params.require(:review).permit(:review, :book_id)
    end
    
    def owned_review
      unless current_user == @review.user
        flash[:danger] = "Error! The review does not belong to you!"
        redirect_to books_path(@book)
      end
    end
end

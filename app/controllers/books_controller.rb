class BooksController < ApplicationController
	before_action :authenticate_user!, :except => [:show, :index, :search]
	before_action :set_book, only: [:show, :edit, :update, :destroy]
	before_action :owned_book, only: [:edit, :update, :destroy]
	
  def index
		@books = Book.paginate(:page => params[:page], :per_page => 30).order('created_at DESC')
		@pages_count = Book.sum(:page_count)
		@books_count = Book.count
  end
  
  def search
  	@results = GoogleBooks.search(params[:search].downcase, :filter => 'partial', :count => 10, :api_key => ENV['API_KEY'])
  	if @results.total_items === 0
  		flash.now[:danger] = "Error! Did not return any search results."
  	else
  		show_form
  	end
  end
  
	def new
		@book = current_user.books.build
	end
	
	def create
		@book = current_user.books.build(book_params)
		if @book.save
			# Handles a successful save.
			flash[:success] = 'Book has been added.'
			redirect_to books_path
		else
			# Handles an error on save.
			flash[:danger] = 'Error! Book has not been added. Book duplicate?'
			 redirect_to books_path
		end
	end
	
	def show
		books = @book
		featured_books(books)
		@review = Review.new
	end
	
	def edit
	end
	
	def update
		 if @book.update_attributes(book_params)
		 		flash[:success] = 'Book has been updated.'
				 redirect_to books_path
		 else
		 		flash[:danger] = 'Error! Book has not been updated.'
				 redirect_to books_path
		 end
	end
	
	def destroy
		@book.destroy
		flash.now[:danger] = "Book has successfully been deleted"
		redirect_to books_path
	end
	
	private
		def book_params
			params.require(:book).permit(:books_id, :image_link, :title, :authors, :publisher, :published_date, :description, :isbn, :page_count, :categories, :average_rating, :ratings_count, :preview_link, :info_link, :user_id, :image_delete)
		end
		
		def set_book
      @book = Book.find(params[:id])
		end
		
		def show_form
			@book = []
			@results.each do |result|
				@book << Book.new
			end
		end
		
		def owned_book
			unless current_user == @book.user
				flash[:danger] = "Error! The book does not belong to you!"
				redirect_to books_path
			end
		end
		
		def featured_books(books)
			# Is an Active Record query where it finds all ids in the table except for the id of the book that we are already
			# on in the show page. It then only shows a select number of random books to display.
			min = Book.first
			max = Book.last
			num_of_books = 4
			@random = Book.where(id: [min..max]).where.not(id: books).shuffle.take(num_of_books)
		end
end

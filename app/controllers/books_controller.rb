class BooksController < ApplicationController
  def index
		@allBooks = Book.all
  end
  def search
  	@results = GoogleBooks.search(params[:search], :filter => 'partial', :count => 10)
  	show_form
  end
	def create
		@books = Book.new(book_params)
		if @books.save
			# Handle a successful save.
			redirect_to books_path
		else
			 render books_path
		end
	end
	def show
		@books = Book.find(params[:id]) 
	end
	def edit
		@book = Book.find(params[:id]) 
	end
		def update
			 @book = Book.find(params[:id])
			 if @book.update_attributes(book_params)
					 redirect_to books_path
			 else
					 render 'edit'
			 end
		end
		
	private
		def book_params
			params.require(:book).permit(:image_link, :title, :authors, :publisher, :published_date, :description, :isbn, :page_count, :categories, :average_rating, :ratings_count, :preview_link, :info_link)
		end
		def show_form
			@books = []
			@results.each do |result|
				@books << Book.new
			end
		end
end

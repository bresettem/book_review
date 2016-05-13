class BooksController < ApplicationController
	before_action :authenticate_user!, :except => [:show, :index, :search]
  def index
		@allBooks = Book.all
		@pages_count = Book.sum(:page_count)
		@books_count = Book.count
		num_of_books = 3
		featured_books(num_of_books)
  end
  def search
  	@results = GoogleBooks.search(params[:search].downcase, :filter => 'partial', :count => 10)
  	if @results.total_items === 0
  		flash.now[:danger] = "Did not return any search results."
  	else
  		show_form
  	end
  end
	def create
		@books = Book.new(book_params)
		if @books.save
			# Handle a successful save.
			flash[:success] = 'Book has been added.'
			redirect_to books_path
		else
			flash[:danger] = 'Book has not been added. Book duplicate?'
			 redirect_to books_path
		end
	end
	def show
		@books = Book.find(params[:id])
		num_of_books = 4
		featured_books(num_of_books)
	end
	def edit
		@book = Book.find(params[:id]) 
	end
		def update
			 @book = Book.find(params[:id])
			 if @book.update_attributes(book_params)
			 		flash[:success] = 'Book has been updated.'
					 redirect_to books_path
			 else
					 redirect_to 'edit'
			 end
		end
		
	private
		def book_params
			params.require(:book).permit(:book_id, :image_link, :title, :authors, :publisher, :published_date, :description, :isbn, :page_count, :categories, :average_rating, :ratings_count, :preview_link, :info_link)
		end
		def show_form
			@books = []
			@results.each do |result|
				@books << Book.new
			end
		end
		def featured_books(num_of_books)
				# In the Book table, randomly generates an array of unique ids, not including the id in @books
			max = Book.count
			@random = Book.find((1..max).to_a.shuffle.take(num_of_books).uniq)
		end
end

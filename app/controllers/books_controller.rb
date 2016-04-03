class BooksController < ApplicationController
    def index
        @books = Book.all
    end
    def new
       @books = Book.new 
    end
    def create
        @books = Book.new(book_params)
        if @books.save
          # Handle a successful save.
          redirect_to genres_path
        else
           render 'new'
        end
    end
    
    private
    def book_params
      params.require(:genre).permit(:book_type,:genre)
    end
end

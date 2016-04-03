class GenresController < ApplicationController
    def index
        @fiction_genre = Genre.where(book_type: 'Fiction').order(genre: :asc)
        @nonfiction_genre = Genre.where(book_type: 'Nonfiction').order(genre: :asc)

    end
    def new
        @genre = Genre.new
    end
    def create
        @genre = Genre.new(genre_params)
        if @genre.save
          # Handle a successful save.
          redirect_to genres_path
        else
           render 'new'
        end
    end
    def edit
       @genre = Genre.find(params[:id]) 
    end
    def update
       @genre = Genre.find(params[:id])
       if @genre.update_attributes(genre_params)
           redirect_to genres_path
       else
           render 'edit'
       end
    end
    def destroy
       @genre = Genre.find(params[:id])
       @genre.destroy
       redirect_to genres_path
    end
  private
    def genre_params
      params.require(:genre).permit(:book_type,:genre)
    end
end

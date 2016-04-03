class AuthorsController < ApplicationController
		def index
				@author = Author.all
		end
		def show
			@author = Author.find(params[:id])
		end
		def new
				@author = Author.new
		end
		def create
        @author = Author.new(author_params)
        if @author.save
          # Handle a successful save.
          redirect_to authors_path
        else
           render 'new'
        end
    end
     def edit
       @author = Author.find(params[:id]) 
    end
    def update
       @author = Author.find(params[:id])
       if @author.update_attributes(author_params)
           redirect_to authors_path
       else
           render 'edit'
       end
    end
    def destroy
       @author = Author.find(params[:id])
       @author.destroy
       redirect_to authors_path
    end
    private
    def author_params
      params.require(:author).permit(:first_name, :last_name, :bio, :other_books, :avatar)
    end
end

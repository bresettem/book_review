class AuthorsController < ApplicationController
	def index
		@authors = Book.select(:authors).where.not(:authors => nil).distinct
	end
end

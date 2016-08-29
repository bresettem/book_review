class AuthorsController < ApplicationController
	def index
		@authors = Book.select(:authors).where.not(:authors => nil, :authors => "").distinct.order('authors ASC')
	end
end

class CategoriesController < ApplicationController
	def index
		@categories = Book.select(:categories).where.not(:categories => nil, :categories => "").distinct.order('categories ASC')
	end
end
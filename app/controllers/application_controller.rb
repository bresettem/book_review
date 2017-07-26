class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :num_per_page
  
  def num_per_page
    @per_page = 5
  end
end

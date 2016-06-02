module BooksHelper
  def ratings_count(result)
    if result.ratings_count.blank? 
      "0 ratings"
    else 
      "#{result.average_rating} with"
      if result.ratings_count === 1 
        "#{result.ratings_count} rating"
      else 
        "#{result.ratings_count} ratings"
      end 
    end 
  end
  
  def page_count(result)
    if result.page_count.blank?
      0
    else
      result.page_count
    end
  end
  
  def authors(result)
    unless result.authors.blank?
      "by #{result.authors}"
    end
  end
  
  def description(result)
    if result.description.blank?
      "No description is available"
    else
        result.description.html_safe
    end
  end
end

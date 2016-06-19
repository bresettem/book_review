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
  
  def published_date(result)
    if result.published_date.blank?
      "No Published Date"
    else
      "Published on #{result.try(:published_date).try(:strftime, "%m/%d/%Y")} by #{result.publisher}"
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
  
  def isbn(result)
    if @book.isbn.blank?
      "No ISBN number"
    else
      result.isbn
    end   
  end
  def missing_image(a)
    if a.image_link.blank?
      link_to (image_tag "missing.svg", class: 'center-block missing-book'), book_path(a)
    else
    	link_to (image_tag a.image_link(:medium), class: 'center-block img-thumbnail caption-img'), book_path(a)
    end
  end
  
  def show_missing_image()
    if @book.image_link.blank?
      link_to (image_tag "missing.svg", class: 'center-block missing-book caption-img'), @book.info_link, :target => '_blank'
    else
      link_to (image_tag @book.image_link(:medium), class: 'center-block img-thumbnail first-image caption-img'), @book.info_link, :target => '_blank'
      #link_to (image_tag 'google_preview.gif', class: 'center-block thumbnail second-image'), @book.info_link, :target => '_blank'
    end
  end
  
  def title()
    if @book.categories.blank?
      "No Genre is available"
    else
      @book.categories
    end
  end
end

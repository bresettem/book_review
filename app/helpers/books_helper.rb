module BooksHelper
  def no_books(books)
    if books === []
      content_tag(:div, "Error! No books have been added.", class: 'alert alert-danger')
    else
		  content_tag(:div, content_tag(:p, "There have been " + pluralize(number_with_delimiter(@books_count), "book") + " added with " + pluralize(number_with_delimiter(@pages_count), "page") + "."), class: 'alert alert-info')
    end 
  end
  
  def average_ratings_count(result)
    average_rating(result) + ratings_count(result)
  end
  
  def ratings_count(result)
    result.ratings_count ? pluralize(number_with_delimiter(result.ratings_count), "rating") : "No Ratings Available"
  end
  
  def average_rating(result)
    result.average_rating ? result.average_rating.to_s + "/" : "No Average Rating/"
  end
  
  def page_count(result)
    result.page_count ? pluralize(number_with_delimiter(result.page_count), "page") : "No Page Available"
  end
  
  def published_date(result)
    if current_page?(action: 'show', id: @book)
      result.published_date ? result.published_date.strftime("Published on %m/%d/%Y") : "No Published Date"
    else
      result.published_date ? result.published_date : "No Published Date"
    end
  end
  
  def publisher(result)
    result.publisher ? content_tag(:div, " by " + result.publisher) : "No Publisher Available"
  end
  
  def title(result)
    result.title ? result.title : "No Title is available"
  end
  
  def authors(result)
    result.authors ? result.authors : "No Author is available"
  end
  def authors(a)
    if a.authors.present?
      content_tag(:p, 'By: ' + truncate(a.authors, length: 40), class: 'wrap-text')
    end
  end
  def description(result)
    result.description ? result.description : "No description is available"
  end
  def isbn(result) 
    result.isbn ? result.isbn : "No ISBN is available"
  end
  def missing_image(a)
    if a.image_link.blank?
      link_to (image_tag "missing.svg", alt: 'Missing Image', class: 'img-thumbnail missing-book caption-img'), book_path(a)
    else
    	link_to (image_tag a.image_link.url(:medium), alt: a.title, class: 'img-thumbnail caption-img'), book_path(a)
    end
  end
  def current_owner(a)
    a.user.id == current_user.id
  end
end

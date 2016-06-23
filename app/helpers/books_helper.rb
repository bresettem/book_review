module BooksHelper
  def ratings_count(result)
    if result.ratings_count.blank? 
      content_tag(:div, "0 ratings")
    else
      content_tag(:div, result.average_rating.to_s + " with")
      if result.ratings_count === 1 
        content_tag(:div, average_rating(result) + result.ratings_count.to_s + " rating ")
        
        #unless result.average_rating.present?
         # content_tag(:div, result.average_rating)
        #end
      else
        content_tag(:div, average_rating(result) + result.ratings_count.to_s + " ratings ")
       # unless result.average_rating.present?
        #  content_tag(:div, result.average_rating)
        #end
      end 
    end 
  end
  
  def average_rating(result)
    if result.average_rating.present?
      result.average_rating.to_s + "/"
    else
      "No average"
    end
  end
  
  def page_count(result)
    if result.page_count.blank?
      content_tag(:div, "0 pages")
    else
      content_tag(:div, number_with_delimiter(result.page_count).to_s + " pages")
    end
  end
  
  def published_date(result)
    if result.published_date.blank?
      content_tag(:div, "No Published Date")
    else
      if current_page?(action: 'show', id: @book)
        content_tag(:div, + "Published on " + result.published_date.strftime("%m/%d/%Y"))
      else
        content_tag(:div, "Published on " + result.try(:published_date).to_s)
      end
    end    
  end
  
  def publisher(result)
    if result.publisher.blank?
      content_tag(:div, "No Publisher Available")
    else
      if current_page?(action: 'show', id: @book)
        content_tag(:div, result.publisher)
      else
        content_tag(:div, " by " + result.publisher)
      end
    end
  end
  def authors(result)
    unless result.authors.blank?
      content_tag(:div, " by " + result.authors)
    end
  end
  
  def description(result)
    if result.description.blank?
      content_tag(:div, "No description is available")
    else
      content_tag(:div, result.description)
    end
  end
  
  def isbn(result)
    if @book.isbn.blank?
      content_tag(:div, "No ISBN Available")
    else
      content_tag(:div, result.isbn)
    end   
  end
  def missing_image(a)
    if a.image_link.blank?
      link_to (image_tag "missing.svg", class: 'center-block missing-book'), book_path(a)
    else
    	link_to (image_tag a.image_link(:medium), class: 'center-block img-thumbnail caption-img'), book_path(a)
    end
  end
  
  def show_missing_image(book)
    if book.image_link.blank?
      link_to (image_tag "missing.svg", class: 'center-block missing-book caption-img'), book.info_link, :target => '_blank'
    else
      link_to (image_tag book.image_link(:medium), class: 'center-block img-thumbnail first-image caption-img'), book.info_link, :target => '_blank'
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

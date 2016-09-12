module AuthorsHelper
  def author()
    @authors.each do |c|
     a=c.authors.split(",")
			a.each do |s|
			content_tag(:li, s)
	 end
 end
  end
end

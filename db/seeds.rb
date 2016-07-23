# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# require 'faker'
books=[]
5.times do |search|
  search = GoogleBooks.search(Faker::Book.title, :count => 40)
  search.each do |a|
    books << a
  end
end
books.each do |result|
  Book.create(
    books_id: result.id,
    image_link: result.image_link,
    title: result.title,
    authors: result.authors,
    publisher: result.publisher,
    published_date: result.published_date,
    description: result.description,
    isbn: result.isbn,
    page_count: result.page_count,
    categories: result.categories,
    average_rating: result.average_rating,
    ratings_count: result.ratings_count,
    preview_link: result.preview_link,
    info_link: result.info_link,
    user_id: 1
  )
end
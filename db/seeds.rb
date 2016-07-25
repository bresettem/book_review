# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'benchmark'
start_books = Book.count
num_times = 5
books=[]

Benchmark.bm do |x|
  x.report { 
    Book.transaction do
      num_times.times do |search|
        random = Faker::Lorem.word
        search = GoogleBooks.search(random, :count => 40)
        Book.transaction do
          search.each do |result|
            books << result
          end
        end
      end
     end
  }

  x.report { 
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
  }
end
end_books=Book.count
added_books = end_books - start_books
p "Start: #{start_books} End: #{end_books} Added #{added_books}"
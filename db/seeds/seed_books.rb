User.create([
  {email: "runiq@hotmail.com", password: "$2a$11$64q6dICwsyCDO9rcC8PbZ.T5xMKJjQdhal3IK0vkPCJ.Os1STsVaO", first_name: "Brandon", last_name: "Grimes", reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil, sign_in_count: 1, current_sign_in_at: "2016-08-04 22:25:23", last_sign_in_at: "2016-08-04 22:25:23", current_sign_in_ip: "70.178.126.178", last_sign_in_ip: "70.178.126.178", user_name: "moxakaxop"}
])
require 'benchmark'
start_books = Book.count
num_times = 20
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
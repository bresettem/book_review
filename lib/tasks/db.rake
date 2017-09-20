=begin
 Purpose: To be able to seed multiple users, books, and reviews at the same.
 time into the database while keeping track of how long it takes.
 Author: Matthew Bresette
=end

require 'set'
require 'benchmark'
require 'action_view'
include Benchmark
include ActionView::Helpers::TextHelper

caption_length = 15
namespace :db do
	namespace :seed do
	
	# Method to call rake db:seed:users[x], x = some Integer value
	desc "Create new users based on Faker and outputs results to db/seed_files/users.txt"
	task :users, [:num_users] => [:environment] do |t, args|
		num_users = args[:num_users].to_i # 
		add_user(caption_length, num_users)
	end
	
	# Method to call rake db:seed:books[x],  x = some Integer value
	desc "Create new books based on Faker and outputs results to db/seed_files/new_books.txt or old_books.txt"
	task :books, [:num_books] => [:environment] do |t, args|
		num_books = args[:num_books].to_i
		add_book(caption_length, num_books)
	end
	
	# Method to call rake db:seed:reviews[x], x = some Integer value
	desc "Create new reviews on Faker and outputs results to db/seed_files/reviews.txt"
	task :reviews, [:num_reviews] => [:environment] do |t, args|
		num_reviews = args[:num_reviews].to_i
		add_review(caption_length, num_reviews)
	end
	
	# Method to call rake db:seed:all[x,y,z], x = y = z = some Integer values
	desc "Runs all create methods and outputs results to db/seed_files"
	task :all, [:num_users, :num_books, :num_reviews] => [:environment] do |t, args|
		num_users = args[:num_users].to_i
		num_books = args[:num_books].to_i
		num_reviews = args[:num_reviews].to_i
		
		add_user(caption_length, num_users)
		add_book(caption_length, num_books)
		add_review(caption_length, num_reviews)
		total_time(caption_length)
	end
	
	# Method to call rake db:seed:total with another method i.e. rake db:seed:reviews[1] db:seed:total  
	# Will return Nothing was seeded if was run by itself
	desc "Adds how long it takes for it to complete"
		task total: :environment do
			total_time(caption_length)
		end
	end
end
=begin
	Creates db/seed_files used while seeding database unless the folder is already there
	
	Overview
		1. Checks to see if the folder 'db/seed_files' exists.
		2. If the folder doesn't exist, then it creates the folder.
		
	Example
		Folder does not exist.
			Created folder 'db/seed_files'
		Folder already exists.
			The function is not run.
=end
def file_exists?
	directory_name = "db/seed_files"
	unless File.exist?(directory_name)
		puts "Created folder 'db/seed_files'"
		Dir.mkdir(directory_name)
	end
end

=begin 
	Generates an amount of users based on the task argument.
	
	Parameters
		num_users [Integer] - Number of users to generate. Uses a task argument. Defaults to 0.
		caption_length [Benchmark] - Required for Benchmark formatting
		
	Overview
		1. Checks to make sure num_users is 0.
		2. Creates folder if it doesn't already exist
		3. User_faker - Generates random usernames, email, password, and last names and stores it in a hash. The randomness comes from Faker.
		4. User_create - Takes the hash and inserts into the database
		5. User_write - Writes the generated output to a file for testing purposes.
		6. Outputs how many users and directs to the generated data.
	
	Examples
		Seeding a user that is either blank or 0.
			rake db:seed:users OR rake db:seed:users[0]
				No Users added.
				
		Seeding only one user.
			rake db:seed:users[1] - num_users must be of Integer value otherwise it will default to 0.
													user     system      total        real
			user_faker        0.350000   0.020000   0.370000 (  0.375199)
			user_create       0.190000   0.080000   0.270000 (  0.294119)
			user_write        0.010000   0.000000   0.010000 (  0.000637)
			total:            0.550000   0.100000   0.650000 (  0.669955)
			Added 1 users.
			See db/seed_files/users.txt
			
			db/seed_files/users.txt - Appends to file
				user_name,email,password - Will only display once at the very top
				example_user_name,hello@example.com,pa$$w0rd
=end
def add_user(caption_length, num_users)
	if num_users == 0
		puts "No Users added."
	else
		file_exists? # Unless folder exists, creates folder
		start_user = User.count
		user = all_users = Hash.new
		Benchmark.benchmark(CAPTION, caption_length, FORMAT, "total:") do |x|
			user_faker = x.report("user_faker") {
				num_users.times do |index|
					User.transaction do
						numbers = Faker::Internet.password(5, 10, true, true) # min_length, max_length, mix_case, special_characters
						user = {
							user_name: Faker::Internet.user_name + numbers,
							email: Faker::Internet.email("#{user[:user_name]} #{numbers}"),
							password: Faker::Internet.password,
							first_name: Faker::Name.first_name,
							last_name: Faker::Name.last_name
						}
						all_users.store(user, user)
					end
				end
			}
			user_create = x.report("user_create") {
				all_users.each_value do |value|
					User.create(
						user_name: value[:user_name],
						email: value[:email], 
						password: value[:password],
						first_name: value[:first_name],
						last_name: value[:last_name]
					)
				end
			}
			user_write = x.report("user_write ") {
				fname = 'db/seed_files/users.txt'
				f = open(fname, 'a')
				unless File.size?(fname)
					f.puts "user_name,email,password"
				end
				all_users.each_value do |v|
					f.puts "#{v[:user_name]},#{v[:email]},#{v[:password]}"
				end
			}
			@user_time = user_faker + user_create + user_write
			[@user_time]
		end
		end_user = User.count
		difference_user = end_user - start_user
		puts "Added #{difference_user} users."
		puts "See db/seed_files/users.txt"
	end
end

=begin 
	Generates an amount of books based on the task argument.
	
	Parameters
		num_books [Integer] - Number of books to generate. Task argument. Defaults to 0.
		caption_length [Benchmark] - Required for Benchmark formatting
		
	Overview
		1. Checks to make sure if a user account is already added.
		2. Checks to make sure num_books is 0.
		3. Creates folder if it doesn't already exist.
		4. Books_faker - Generates a word and searches through GoogleBooks.
			a. Generates a random word from Faker.
			b. Takes the randomized word and searches GoogleBooks. The largest number of books to search is 40. 
			c. Takes the returned value from GoogleBooks and sorts them depending on if they are new or old books.
		5. Books_create - Only adds the new books. 
		6. Books_write - Writes the generated output for the new and/or old books to a file.
		7. Outputs the book details for the new and old books as well as the total number of books searched.
	
	Examples
		Seeding a book that has no user accounts added. Adding a book requires a user account to add.
			rake db:seed:books[1]
			Error! No users added. Please add a user account before adding books.
			
		Seeding a book that has a task argument blank or 0.
			rake db:seed:books OR rake db:seed:books[0]
				No Books added.
				
		Searching two books
			rake db:seed:books[2]
															user     system      total        real
				books_faker       0.280000   0.020000   0.300000 (  0.860452)
				books_create      0.080000   0.010000   0.170000 (  0.342009)
				books_write       0.010000   0.000000   0.010000 (  0.010923)
				total:            0.370000   0.030000   0.480000 (  1.213384)
				New books: 1. Old books: 1. Total books searched 2.
				See new_books.txt and/or old_books.txt to see a list in db/seed_files.
				
			db/seed_files/old_books.txt
				old_books: 1/2
				#|books_id|title|isbn|created_at|user_id
				1|pvt9FaISGXkC|Finding Nemo Junior Noveliz...|9781423180487|09/19/2016 03:22:53 AM|8341
			db/seed_files/new_books.txt
				new_books: 1/2
				#|books_id|title|isbn|user_id
				1|CRkowJ1D5OAC|The Non-Designer&#39;s Design Book|9780132103923|4158
=end
def add_book(caption_length, num_books)
	@user_id = User.ids.sample # Returns a random user_id
	if @user_id.blank?
		puts "Error! No users added. Please add a user account before adding books."
	elsif num_books == 0
		puts "No Books added."
	else
		file_exists?
		sum = 0
		num_books_to_search = 1 # Maximum number to search is 40 books per search.
		new_books = Set.new 
		old_books = Set.new
		book_id = Set.new
		book_id = Book.all.pluck(:books_id) # Get all books_id to compare to books in the database
		Benchmark.benchmark(CAPTION, caption_length, FORMAT, "total:") do |x|
			books_faker = x.report("books_faker") { 
				Book.transaction do
					num_books.times do |search|
						random = Faker::Lorem.word
						search = GoogleBooks.search(random, count: num_books_to_search, api_key: ENV['API_KEY'])
						search.each do |s|
							if book_id.blank?
								new_books << s
							else
								book_id.each do |b| # Compares each book_id to see if the book has already been added.
									if s.id.eql?(b)
										#puts "#{b} = #{s.id}" Book has already been added i.e a old book.
										old_books << s
									else
										# puts "#{b} != #{s.id}" Book is not bee added ie. a new book.
										new_books << s
									end
								end
							end
						end
					end
				end
			}
			new_books = new_books - old_books;
			books_create = x.report("books_create") {
				new_books.each do |result|
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
						user_id: @user_id
					)
				end
			}
			sum = new_books.count + old_books.count
			books_write = x.report("books_write ") {
				open('db/seed_files/new_books.txt', 'w') do |f|
					
					if new_books.count == 0
						f.print "No new books added."
					else
						index = 0
						f.puts "new_books: #{new_books.count}/#{sum}"
						f.puts "#|books_id|title|isbn|created_at|user_id"
						new_books.each do |a|
							index += 1
							b = Book.find_by_books_id(a.id)
							b_created = b.created_at.strftime('%m/%d/%Y %I:%M:%S %p')
							b_user_id = b.user_id
							f.puts "#{index}|#{a.id}|#{truncate(a.title)}|#{a.isbn}|#{b_created}|#{b_user_id}"
						end
					end
				end
				open('db/seed_files/old_books.txt', 'w') do |f|
					if old_books.count == 0
						f.print "No old books added."
					else
						index = 0
						f.puts "old_books: #{old_books.count}/#{sum}"
						f.puts "#|books_id|title|isbn|created_at|user_id"
						old_books.each do |a|
							index += 1
							b = Book.find_by_books_id(a.id)
							b_created = b.created_at.strftime('%m/%d/%Y %I:%M:%S %p')
							b_user_id = b.user_id
							f.puts "#{index}|#{a.id}|#{truncate(a.title)}|#{a.isbn}|#{b_created}|#{b_user_id}"
						end
					end
				end	
			}
			@book_time = books_faker + books_create + books_write
			[@book_time]
		end
		puts "Error! No users added. Please add a user account before adding books." if @user_id.nil?
		puts "New books: #{new_books.count}. Old books: #{old_books.count}. Total books searched #{sum}."
		puts "See new_books.txt and/or old_books.txt to see a list in db/seed_files."
	end
end
=begin 
	Generates an amount of reviews based on a task argument.
	
	Parameters
		num_reviews [Integer] - Number of reviews to generate. Uses a task argument. Defaults to 0.
		caption_length [Benchmark] - Required for Benchmark formatting
		
	Overview
		1. Checks to make sure a book has already been added. 
		2. Checks to make sure num_reviews is 0.
		3. Creates folder if it doesn't already exist.
		4. Review_faker - Generates random reviews on a random book.
		5. Review_create - Adds the review to the database.
		6. Review_write - Writes the generated output for the reviews to a file.
		7. Outputs how many reviews added. Directs to the generated data.
	
	Examples
		Seeding a review that has no books added. Books must exist before adding reviews.
			rake db:seed:reviews[1]
			Error! No reviews added. Please add a book before adding reviews.
		Seeding a review that has a task argument of blank or 0.
			rake db:seed:reviews OR rake db:seed:reviews[0]
				No Reviews added.
				
		Adding one review.
			rake db:seed:reviews[1]
															user     system      total        real
				review_faker:     0.290000   0.020000   0.310000 (  0.314859)
				review_create:    0.010000   0.000000   0.010000 (  0.036784)
				review_write:     0.000000   0.000000   0.000000 (  0.003893)
				total:            0.300000   0.020000   0.320000 (  0.355536)
				Added 1 reviews.
				See reviews.txt to see a list in db/seed_files.        
			db/seed_files/reviews.txt
				user_id,book.id,review
				165,3715,Cupiditate consectetur quisquam. Laudantium consectetur sapiente commodi perspiciatis. Veritatis eos dignissimos in. Delectus non amet qui qui non est. Eligendi fugit blanditiis. Est consequatur sunt voluptatem.
=end
def add_review(caption_length, num_reviews)
	book_id = Book.ids.sample;
	if book_id.blank?
		puts "Error! No reviews added. Please add a book before adding reviews."
	elsif num_reviews == 0
		puts "No Reviews added."
	else
		file_exists?
		add_reviews = Set.new
		book_id = Book.ids.sample
		book = Book.find_by_id(book_id)
		start_review = book.reviews.count
		
		Benchmark.benchmark(CAPTION, caption_length, FORMAT, "total:") do |x|
			review_faker = x.report("review_faker:") {
				num_reviews.times do 
					Review.transaction do
						random = Faker::Lorem.paragraph(6)
						add_reviews << random
					 end
				end
			}
			review_create = x.report("review_create:") { 
				add_reviews.each do |result|
					Review.create(
						review: result,
						user_id: book.user_id,
						book_id: book.id
					)
				end
			}
			review_write = x.report("review_write:") {
				open('db/seed_files/reviews.txt', 'w') do |f|
					f.puts "user_id,book.id,review"
					add_reviews.each do |a|
						f.print "#{book.user_id},#{book.id},#{a} \n"
					end
				end	
			}
			@review_time = review_faker + review_create + review_write
			[@review_time]
		end
		end_review = book.reviews.count
		difference_review = end_review - start_review
		puts "Added #{difference_review} reviews."
		puts "See reviews.txt to see a list in db/seed_files."
	end
end
=begin 
	Calculates the total time it takes to run.
	
	Parameters
		caption_length [Benchmark] - Required for Benchmark formatting
		
	Overview
		1. Checks to see if users, books, or reviews were run.
		2. Outputs total time ran
	
	Examples
		Calling total_time by itself
			rake db:seed:total
				No time to show.
				
		Seeding reviews along with calling total time
			rake db:seed:reviews[1] db:seed:total
															user     system      total        real
				review_faker:     0.270000   0.010000   0.280000 (  0.279296)
				review_create:    0.010000   0.010000   0.020000 (  0.020815)
				review_write:     0.000000   0.000000   0.000000 (  0.000201)
				total:            0.280000   0.020000   0.300000 (  0.300312)
				Added 1 reviews.
				See reviews.txt to see a list in db/seed_files.
															user     system      total        real
				total:            0.280000   0.020000   0.300000 (  0.300312)
				avg:              0.280000   0.020000   0.300000 (  0.300312)
		
		Seeding users and reviews while calculating total time
			rake db:seed:users[1] db:seed:reviews[1] db:seed:total
															user     system      total        real
				user_faker        0.290000   0.020000   0.310000 (  0.314696)
				user_create       0.180000   0.010000   0.190000 (  0.202936)
				user_write        0.000000   0.010000   0.010000 (  0.000125)
				total:            0.470000   0.040000   0.510000 (  0.517757)
				Added 1 users.
				See db/seed_files/users.txt
															user     system      total        real
				review_faker:     0.000000   0.000000   0.000000 (  0.000664)
				review_create:    0.000000   0.010000   0.010000 (  0.017783)
				review_write:     0.000000   0.000000   0.000000 (  0.000146)
				total:            0.000000   0.010000   0.010000 (  0.018593)
				Added 1 reviews.
				See reviews.txt to see a list in db/seed_files.
															user     system      total        real
				total:            0.470000   0.050000   0.520000 (  0.536349)
				avg:              0.235000   0.025000   0.260000 (  0.268175)
=end
def total_time(caption_length)
	count = 0
	unless @user_time.nil? 
		count += 1
	end
	unless @book_time.nil?
		count += 1
	end
	unless @review_time.nil?
		count += 1
	end
	if count.nil? || count == 0
		puts "No time to show."
	else
		Benchmark.benchmark(CAPTION, caption_length, FORMAT, "total:", "avg:") do |x|
			total_time = [@user_time, @book_time, @review_time].compact.inject(&:+)
			[total_time, total_time / count]
		end
	end
end
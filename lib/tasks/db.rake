include Benchmark
include ActionView::Helpers::TextHelper
require 'set'
caption_length = 15

namespace :db do
  namespace :seed do
	
	# Method to call rake db:seed:users[x], x = some int variable
	desc "Create new users based on Faker and outputs results to db\\seed_files\\users.txt"
	task :users, [:num_users] => [:environment] do |t, args|
		num_users = args[:num_users].to_i
		add_user(caption_length, num_users)
	end
  
  # Method to call rake db:seed:books[x],  x = some int variable
	desc "Create new books based on Faker and outputs results to db\\seed_files\\new_books.txt or old_books.txt"
	task :books, [:num_books] => [:environment] do |t, args|
		num_books = args[:num_books].to_i
		add_book(caption_length, num_books)
	end
  
  # Method to call rake db:seed:reviews[x], x = some int variable
	desc "Create new reviews on Faker and outputs results to db\\seed_files\\reviews.txt"
	task :reviews, [:num_reviews] => [:environment] do |t, args|
		num_reviews = args[:num_reviews].to_i
			add_review(caption_length, num_reviews)    	
	end
	
	# Method to call rake db:seed:all[x,y,z], x = y = z = some int variable
	desc "Runs all create methods and outputs results to db\\seed_files"
	task :all, [:num_users, :num_books, :num_reviews] => [:environment] do |t, args|
		num_users = args[:num_users].to_i
		num_books = args[:num_books].to_i
		num_reviews = args[:num_reviews].to_i
		
		add_user(caption_length, num_users)
		add_book(caption_length, num_books)
		add_review(caption_length, num_reviews)
		total_time(caption_length)
	end
	
	# Method to call rake db:seed:total
	# Will return Nothing was seeded if was run by itself
	desc "Adds how long it takes for it to complete"
	  task total: :environment do
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
				puts "Nothing was seeded"
			else
				Benchmark.benchmark(CAPTION, caption_length, FORMAT, "total:", "avg:") do |x|
					total_time = [@user_time, @book_time, @review_time].compact.inject(&:+)
					[total_time, total_time / count]
				end
			end
	  end
  end
end

def file_exists
	Dir.chdir(File.dirname(__FILE__))
	directory_name = "seed_files"
	Dir.mkdir(directory_name) unless File.exists?(directory_name)
end

def add_user(caption_length, num_users)
	start_user = User.count
	user = all_users = Hash.new
	Benchmark.benchmark(CAPTION, caption_length, FORMAT, "total:") do |x|
		user_faker = x.report("user_faker") {
			num_users.times do |index|
				User.transaction do
					numbers = Faker::Internet.password(5, 10, true, true)
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
				f.puts "user_name,email, password"
			end
			all_users.each_value do |v|
				f.puts "#{v[:user_name]},#{v[:email]}, #{v[:password]}"
			end
		}
		@user_time = user_faker + user_create + user_write
		[@user_time]
	end
	end_user = User.count
	difference_user = end_user - start_user
	puts "Added #{difference_user} users."
	puts "See db\\seed_files\\users.txt"
end

def add_book(caption_length, num_books)
	sum = 0
	num_books_to_search = 40
	new_books = Set.new
	old_books = Set.new
	book_id = Book.all.pluck(:books_id)
	
	Benchmark.benchmark(CAPTION, caption_length, FORMAT, "total:") do |x|
		books_faker = x.report("books_faker") { 
			Book.transaction do
				num_books.times do |search|
					random = Faker::Lorem.word
					search = GoogleBooks.search(random, count: num_books_to_search)
					search.each do |s|
						book_id.each do |b|
							if s.id.eql?(b)
								#puts "#{b} = #{s.id}"
								old_books << s
							else
								#puts "#{b} != #{s.id}"
								new_books << s
							end
						end
					end
				end
			end
		}
		new_books = new_books - old_books;
		books_create = x.report("books_create") {
			@user_id = User.ids.sample
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
				f.puts "new_books: #{new_books.count}/#{sum}"
				index = 0
				unless new_books.count == 0
					f.puts "#|books_id|title|isbn|user_id"
				end
				new_books.each do |a|
					index += 1
					f.puts "#{index}| #{a.id}| #{truncate(a.title)}| #{a.isbn}| #{@user_id}"
				end
			end
			open('db/seed_files/old_books.txt', 'w') do |f|
				f.puts "old_books: #{old_books.count}/#{sum}"
				index = 0
				f.puts "#|books_id|title|isbn|created_at|user_id"
				old_books.each do |a|
					index += 1
					b = Book.find_by_books_id(a.id)
					b_created = b.created_at.strftime('%m/%d/%Y %I:%M:%S %p')
					b_user_id = b.user_id
					f.puts "#{index}|#{a.id}|#{truncate(a.title)}|#{a.isbn}|#{b_created}|#{b_user_id}"
				end
			end	
		}
		@book_time = books_faker + books_create + books_write
		[@book_time]
	end
	puts "New books: #{new_books.count}. Old books: #{old_books.count}. Total books searched #{sum}."
	puts "See new_books.txt and/or old_books.txt to see a list in db\\seed_files."
end

def add_review(caption_length, num_reviews)
	book_id = Book.ids.sample
	book = Book.find_by_id(book_id)
	start_review = book.reviews.count
	add_reviews = []
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
				f.puts "user_id, book.id, review"
				add_reviews.each do |a|
					f.print "#{book.user_id}, #{book.id}, #{a} \n"
				end
			end	
		}
		@review_time = review_faker + review_create + review_write
		[@review_time]
	end
	end_review = book.reviews.count
	difference_review = end_review - start_review
	puts "Added #{difference_review} reviews."
	puts "See reviews.txt to see a list in db\\seed_files."
	
end

def total_time(caption_length)
	Benchmark.benchmark(CAPTION, caption_length, FORMAT, "total:", "avg:") do |x|
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
			puts "Nothing was seeded"
		else
			total_time = [@user_time, @book_time, @review_time].compact.inject(&:+)
			[total_time, total_time / count]
		end
	end
end
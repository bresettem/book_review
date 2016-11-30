# Book Review
A site to add books from GoogleBooks and add reviews to added Books

**Installation**

 1. `git clone https://github.com/bresettem/book_review.git`
 2. Run `bundle install` and wait for it to finish installing
 3. In the config folder
	* Remove the `.example` on the end of
    `secrets.yml.example`
	* Run `rake secret` and replace `secret_key_base` with a newly generated secret.
 4.  Run a migration
	* `rake db:migrate`
 5.  Install ImageMagick for Paperclip
	* `sudo apt-get update`. If it doesn't work the first time, then try it again.
	* `sudo apt-get install imagemagick`. Type 'y' then press enter to install.
 6. Restart the server if it's already running
 7. Enjoy!

**Seeding** **the** **database**

*Note*: Preferred order is Users, Books, and then Reviews. Books must have a
User account added before adding books. Reviews must have books to add
reviews too. The higher the number of users, books, or reviews to add, the longer it takes to add them. It is not ideal to add a large number all at once.

 1. Adding users
	* `rake db:seed:users[x]` – The value of x is any Integer value i.e. `rake
	db:seed:users[1]`.
	* It creates a file named `db/seed_files_users.txt` for user details.
 2. Adding books
	 * `rake db:seed:books[x]` – The value of x is any Integer value i.e.
    `rake db:seed:books[1]`.
	 * It creates two files named `db/seed_files/new_books.txt` and
    `db/seed_files/old_books.txt`.
 3. Adding reviews
    * `rake db:seed:reviews[x]` – The value of x is any Integer value i.e. `rake
    db:seed:reviews[1]`.
    * It creates a file named `db/seed_files/reviews.txt` to see which user created the review, the book id the review was created, and the text of
        the review.

**Calculating Duration**

 1. Adding `db:seed:total` on the end of the seed will add the total time elapsed on the end i.e. `rake db:seed:users[1] rake db:seed:reviews[1] rake
    db:seed:total`.

**Seeding everything all at once**


 1. Add users, books, and reviews while calculating the total elapsed time to
    complete all tasks  at the same time.
 2. `Rake db:seed:all[x,y,z]` – The value of x,y, and is any Integer value
    i.e. `rake db:seed:all[1,2,3]`. Adds 1 user, 2 books, and 3 reviews respectfully.

**Recommendations**


 1. Getting an API key from GoogleBooks is recommended, but is not required. Without an API key, there is a daily limit of searching for books and if the quota is exceeded, then no book will be found even though it will be a valid book title.
    Read more here https://developers.google.com/books/docs/v1/using?csw=1
 2. To store images on Heroku’s production server use Amazon’s S3 storage
	 * In the `config/application.yml.example`, get rid of `.example`
	 * Follow the tutorial on https://devcenter.heroku.com/articles/s3.
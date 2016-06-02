class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :book
  
  validates :review, :book_id, presence: true
  
  default_scope { order('created_at DESC') }
end

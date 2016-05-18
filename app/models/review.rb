class Review < ActiveRecord::Base
  belongs_to :user
  validates :review, :user_id, presence: true
end

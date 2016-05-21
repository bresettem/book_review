class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_many :reviews, dependent: :destroy
  has_many :books, dependent: :destroy
  validates :first_name, :last_name, presence: true
  validates :user_name, presence: true, length: { minimum: 4 }
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end

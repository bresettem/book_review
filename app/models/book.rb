class Book < ActiveRecord::Base
    #has_many :book_categories
    #has_many :categories, through: :book_categories
    #accepts_nested_attributes_for :book_categories
    validates :info_link, :presence => true, :uniqueness => true
    
    has_attached_file :image_link, styles: { medium: "128>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
    validates_attachment_content_type :image_link, content_type: /\Aimage\/.*\Z/
end

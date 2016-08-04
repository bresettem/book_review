class Book < ActiveRecord::Base
  before_save :destroy_image?
  belongs_to :user
  has_many :reviews, dependent: :destroy
  
  validates :user_id, presence: true
  validates :books_id, :presence => true, :uniqueness => true
  
  has_attached_file :image_link, styles: { medium: "128>", thumb: "100x100>" },
      bucket: ENV["AWS_S3_BUCKET"], 
      s3_host_name: ENV["AWS_S3_HOST_NAME"],
      access_key_id: ENV["AWS_ACCESS_KEY_ID"], 
      secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
      s3_region: ENV["S3_REGION"]

  validates_attachment_content_type :image_link, content_type: /\Aimage\/.*\Z/

  def image_delete
    @image_delete ||= "0"
  end

  def image_delete=(value)
    @image_delete = value
  end

  private
    def destroy_image?
      self.image_link.clear if @image_delete == "1"
    end    
end

class Book < ActiveRecord::Base
    belongs_to :user
    has_many :reviews, dependent: :destroy
    
    validates :user_id, presence: true
    validates :books_id, :presence => true, :uniqueness => true
    
    has_attached_file :image_link, styles: { medium: "128>", thumb: "100x100>" },
                        :storage => :s3,
                                   :s3_credentials => Proc.new{|a| a.instance.s3_credentials }
    def s3_credentials
      {
        :bucket => ENV["AWS_S3_BUCKET"], 
        :access_key_id => ENV["AWS_ACCESS_KEY_ID"], 
        :secret_access_key => ENV["AWS_SECRET_ACCESS_KEY"],
        :s3_region => ENV["S3_REGION"]
      }
      
    end 
    validates_attachment_content_type :image_link, content_type: /\Aimage\/.*\Z/
    
    before_save :destroy_image?

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

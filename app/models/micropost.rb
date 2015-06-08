class Micropost < ActiveRecord::Base
  belongs_to :user
  
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate :picture_size

  mount_uploader :picture, PictureUploader

  def picture_size
  	if picture.size > 5.megabytes
  		errors.add(:picture, "should be less than 5MB")
  	end
  end

  def self.default_scope
  	order(created_at: :desc)
  end
  
  # this works too but it's weirder:
  #default_scope -> { order(created_at: :desc) }

end

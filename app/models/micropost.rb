class Micropost < ActiveRecord::Base
  belongs_to :user
  
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }


  def self.default_scope
  	order(created_at: :desc)
  end
  
  # this works too but it's weirder:
  #default_scope -> { order(created_at: :desc) }

end

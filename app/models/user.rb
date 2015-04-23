class User < ActiveRecord::Base
	before_save {
		self.email = email.downcase	
	}

	validates :name, presence: true, length: { maximum: 50 }

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i # A CONSTANT
	validates :email, uniqueness: { case_sensitive: false }, presence: true, length: {maximum: 255 }, format: { with: VALID_EMAIL_REGEX }





end

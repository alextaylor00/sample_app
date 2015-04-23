class User < ActiveRecord::Base
	before_save {
		self.email = email.downcase	
	}

	validates :name, presence: true, length: { maximum: 50 }

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i # A CONSTANT
	validates :email, uniqueness: { case_sensitive: false }, presence: true, length: {maximum: 255 }, format: { with: VALID_EMAIL_REGEX }

	has_secure_password 
		# adds an authenticate method which returns user object upon successful login; 
		# adds functionaltiy for password_digest attribute for storing hash; 
		# REQUIRES password_digest to be created explicitly
		# adds password and password_confirmation fields




end

class User < ActiveRecord::Base
	before_save do
		email.downcase!
	end

	validates :name, presence: true, length: { maximum: 50 }

	VALID_EMAIL_REGEX 	= /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i 
	VALID_EMAIL_REGEX_2 = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i # DISALLOWS MULTIPLE DOTS
	validates :email, uniqueness: { case_sensitive: false }, presence: true, length: {maximum: 255 }, format: { with: VALID_EMAIL_REGEX_2 }





end

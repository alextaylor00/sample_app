class User < ActiveRecord::Base
	attr_accessor :remember_token # virtual attribute, will not be stored in db

	before_save do
		self.email = email.downcase
	end

	validates :name, presence: true, length: { maximum: 50 }

	VALID_EMAIL_REGEX 	= /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i 
	VALID_EMAIL_REGEX_2 = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i # DISALLOWS MULTIPLE DOTS
	validates :email, uniqueness: { case_sensitive: false }, presence: true, length: {maximum: 255 }, format: { with: VALID_EMAIL_REGEX_2 }

	validates :password, length: { minimum: 6 }

	has_secure_password # requires bcrypt

	# Remembers a user by generating a token and storing its digest in the db.
	def remember
		self.remember_token = User.new_token
		update_attribute(:remember_digest, User.digest(remember_token))
	end

	# Forgets a user by setting the token digest to nil.
	def forget
		update_attribute(:remember_digest, nil)
	end

	# Returns true if the given token matches the digest.
	def authenticated?(remember_token)
		return false if remember_digest.nil?
		BCrypt::Password.new(remember_digest).is_password?(remember_token)
	end


	# Returns a hash digest (for password hashing)
	# The "User." makes it a class method, not an instance method
	def User.digest(string)
	    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
	                                                  BCrypt::Engine.cost
	    BCrypt::Password.create(string, cost: cost)		
	end

	# Returns a random token (for remember-me)
	def User.new_token
		SecureRandom.urlsafe_base64
	end
end

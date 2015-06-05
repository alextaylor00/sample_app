class User < ActiveRecord::Base
	attr_accessor :remember_token, :activation_token # virtual attribute, will not be stored in db

	before_save :downcase_email
	before_create :create_activation_digest

	validates :name, presence: true, length: { maximum: 50 }

	VALID_EMAIL_REGEX 	= /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i 
	VALID_EMAIL_REGEX_2 = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i # DISALLOWS MULTIPLE DOTS
	validates :email, uniqueness: { case_sensitive: false }, presence: true, length: {maximum: 255 }, format: { with: VALID_EMAIL_REGEX_2 }

	validates :password, length: { minimum: 6 }, allow_blank: true

	has_secure_password # requires bcrypt

	# Activates an account.
	def activate
		update_attribute(:activated,		true)
		update_attribute(:activated_at,		Time.zone.now)
	end

	def send_activation_email
		UserMailer.account_activation(self).deliver_now
	end

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
	def authenticated?(attribute, token)
		digest = send("#{attribute}_digest")
		return false if digest.nil?
		BCrypt::Password.new(digest).is_password?(token)
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

	private

	def downcase_email
		self.email = email.downcase
	end

	def create_activation_digest
		self.activation_token = User.new_token
		self.activation_digest = User.digest(activation_token)
	end

end

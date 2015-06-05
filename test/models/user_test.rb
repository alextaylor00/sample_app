require 'test_helper'

class UserTest < ActiveSupport::TestCase

	def setup
		# set up a fake valid user to use in all tests
		@user = User.new(name: "Alex Taylor", email: "ataylor@skylabhq.com",
							password: "foobar", password_confirmation: "foobar")
	end

	test "should be valid" do
		assert @user.valid?
	end

	test "name should be present" do
		@user.name = " "
		assert_not @user.valid?
	end

	test "name should be 50 characters or less" do
		@user.name = "a" * 51
		assert_not @user.valid?
	end


	test "email should be present" do
		@user.email = " "
		assert_not @user.valid?
	end

	test "email should be 255 characters or less" do
		@user.email = "a" * 244 + "@example.com"
		assert_not @user.valid?
	end

	test "email should be a valid format" do
		emails = %w[alex@example.com alex-taylor@example.com alex-taylor@example.co.uk]

		emails.each do |e|
			@user.email = e
			assert @user.valid?, "#{e.inspect} should be valid"
		end
	end

	test "email validation should reject invalid addresses" do
		emails = %w[alexexample.com alex@examplecom alex@example,com alex@example..com]

		emails.each do |e|
			@user.email = e
			assert_not @user.valid?, "#{e.inspect} should not be valid"
		end		
	end


	test "email address should be unique" do
		duplicate_user = @user.dup
		duplicate_user.email = @user.email.upcase
		@user.save
		assert_not duplicate_user.valid?
	end

	test "emails should be lowercase" do
		mixed_case_email = "aLex@SkYLabHQ.com"
		@user.email = mixed_case_email
		@user.save
		assert_equal mixed_case_email.downcase, @user.reload.email
	end

	test "password should have a minimum length" do
		@user.password = @user.password_confirmation = "a" * 5
		assert_not @user.valid?
	end


	test "authenticated? should return false for a user with nil digest" do 
		assert_not @user.authenticated?(:remember, '')
	end

end

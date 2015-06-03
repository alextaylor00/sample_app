require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

	def setup
		@user = users(:alex)
	end

	test "unsuccessful edit" do
		log_in_as @user
		get edit_user_path(@user)
		assert_template 'users/edit'
		patch user_path(@user), user: { name:    				"",
										email:    				"foo@invalid",
										password: 				"foo",
										password_confirmation:  "bar" }

		assert_template 'users/edit'
	end

	test "successful edit" do
		log_in_as @user
		get edit_user_path(@user)
		assert_template 'users/edit'

		name = "Real Name"
		email = "email@email.com"

		patch user_path(@user),	user: {  name:        name,
		                                 email:       email, 
		                                 password:    "",
		                                 password_confirmation: ""
		                                 }
		assert_redirected_to user_path
		assert_not flash.empty?

		@user.reload

		assert_equal name, @user.name
		assert_equal email, @user.email
	end

	test "successful edit with friendly forwarding" do
		get edit_user_path(@user)
		assert_redirected_to login_path
		assert_equal edit_user_url(@user), session[:forwarding_url]
		
		log_in_as @user
		assert_redirected_to edit_user_path(@user)

		name = "New Name"
		email = "new@email.com"

		patch user_path(@user), user: { name: name, email: email }

		assert_not_empty flash
		assert_redirected_to @user

		@user.reload # never forget this!
		assert_equal name, @user.name
		assert_equal email, @user.email

		log_in_as @user
		assert_redirected_to user_path(@user)
	end

end

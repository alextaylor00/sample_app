require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
	def setup
		ActionMailer::Base.deliveries.clear
		@user = users(:alex)
	end

	test "password reset with invalid email" do
		get new_password_reset_path
		assert_template 'password_resets/new'
		post password_resets_path, password_reset: { email: ""}
		assert_template 'password_resets/new'
		assert_not flash.empty?
	end

	test "password reset with valid info" do
		get new_password_reset_path
		post password_resets_path, password_reset: { email: @user.email}
		assert_not_equal @user.reset_digest, @user.reload.reset_digest
		assert_equal 1, ActionMailer::Base.deliveries.size
		assert_not flash.empty?
		assert_redirected_to root_url

		user = assigns(:user)

		# Wrong email
		get edit_password_reset_path(user.reset_token, email: "")
		assert_redirected_to root_url

		# Inactive user
		user.toggle!(:activated)
		get edit_password_reset_path(user.reset_token, email: user.email)
		assert_redirected_to root_url
		user.toggle!(:activated)

		# Right email, wrong token
		get edit_password_reset_path("bad", email: user.email)
		assert_redirected_to root_url

		# Right email, right token
		get edit_password_reset_path(user.reset_token, email: user.email)
		assert_template 'password_resets/edit'
		assert_select "input[name=email][type=hidden][value=?]", user.email

		# Invalid password
		patch password_reset_path(user.reset_token), email: user.email,
											user: { password: "sdf",
													password_confirmation: "ccx"}
        
        assert_template 'password_resets/edit'

        # Empty password
		patch password_reset_path(user.reset_token), email: user.email,
											user: { password: "",
													password_confirmation: ""}
		assert_template 'password_resets/edit'

		# Valid password

		patch password_reset_path(user.reset_token), email: user.email,
											user: { password: "password",
													password_confirmation: "password"}
		assert is_logged_in?
		assert_not flash.empty?
		assert_redirected_to user

	end

end

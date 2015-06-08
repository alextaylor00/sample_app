require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest


	def setup
		@user = users(:alex)
	end

	test "micropost workflow" do
		# log in
		log_in_as @user
		assert_redirected_to @user
		follow_redirect!
		assert_template 'users/show'

		# check the micropost pagination
		assert_select 'div.pagination'
		assert_select 'ol.microposts li', count: 30
		assert_select 'a', text: 'delete'

		get root_path
		assert_template 'static_pages/home'
		
		# make an invalid submission
		assert_no_difference 'Micropost.count' do
			post microposts_path, micropost: { content: '' }
		end

		assert_select 'div.alert.alert-danger'
		
		# make a valid submission
		assert_difference 'Micropost.count', 1 do
			post microposts_path, micropost: { content: 'test micropost' }
		end

		# delete a post
		assert_difference 'Micropost.count', -1 do
			delete micropost_path(@user.microposts.first)
		end

		# visit a second user’s page to make sure there are no “delete” links.
		get user_path(users(:john))
		assert_template 'users/show'
		assert_select 'a', text: 'delete', count: 0

	end

end

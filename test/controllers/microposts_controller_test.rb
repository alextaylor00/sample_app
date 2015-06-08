require 'test_helper'

class MicropostsControllerTest < ActionController::TestCase

	def setup
		@user = users(:alex)
		@micropost = microposts(:orange)
		@micropost_other_user = microposts(:tau_manifesto)
	end

	test "should redirect create when not logged in" do
		assert_no_difference 'Micropost.count' do
			post :create, micropost: { content: "Testing" }
		end

		assert_redirected_to login_url
	end

	test "should redirect destroy when not logged in" do
		assert_no_difference 'Micropost.count' do
			delete :destroy, id: @micropost
		end

		assert_redirected_to login_url
	end

	test "should not allow users to delete each other's microposts" do 
		log_in_as @user
		assert_no_difference 'Micropost.count' do
			delete :destroy, id: @micropost_other_user
		end
	end

end

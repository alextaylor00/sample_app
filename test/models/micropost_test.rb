require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

	def setup
		@user = users(:alex)
		@micropost = @user.microposts.build(content: "Test")
	end

	test "should be valid" do 
		assert @micropost.valid?
	end

	test "user id should be present" do
		@micropost.user_id = nil
		assert_not @micropost.valid?
	end

	test "content should be present" do
		@micropost.content = ""
		assert_not @micropost.valid?
	end

	test "content should not allow more than 140 characters" do
		text = "a" * 141
		@micropost.content = text
		assert_not @micropost.valid?
	end


	test "order should be most recent first" do 
		assert_equal microposts(:most_recent), Micropost.first
	end

end

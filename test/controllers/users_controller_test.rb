require 'test_helper'
require 'byebug'

class UsersControllerTest < ActionController::TestCase

  def setup
  	@user = 		users(:alex)
  	@user_other = 	users(:john)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "edit or update without logging in should produce warning" do
  	get :edit, id: @user
  	assert_not_empty flash
  	assert_redirected_to login_url
  	
    patch :update, { id: @user, user: {  name:  @user.name, email:  @user.email, } }
  	assert_not_empty flash
  	assert_redirected_to login_url

  end

  test "edit or update while logged in should get correct page" do
  	log_in_as @user	
  	get :edit, id: @user
  	assert_template 'users/edit'
  	patch :update, { id: @user, user: {  name:  @user.name, email:  @user.email,  } }
  	assert_redirected_to user_path
  end

  test "user cannot edit other user's information" do
  	log_in_as @user
  	get :edit, id: @user_other
  	assert_not_empty flash
  	assert_redirected_to root_url
  	patch :update, { id: @user_other, user: {  name:  @user_other.name, email:  @user_other.email, } }
  	assert_not_empty flash
  	assert_redirected_to root_url
  end

  test "should redirect to index when not logged in" do
  	get :index
  	assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end

    assert_redirected_to login_url
  end

  test "should redirect destroy when not admin" do
    log_in_as @user_other

    assert_no_difference 'User.count' do
      delete :destroy, id: @user  
    end

    assert_redirected_to root_url
  end

  test "should not allow the admin attribute to be edited via the web" do
    log_in_as @user_other
    assert_not @user_other.admin?

    patch :update, id: @user_other, user: { password: 'password',
                                            password_confirmation: 'password',
                                            admin: 1 }

    assert_not @user_other.reload.admin?
  end



end

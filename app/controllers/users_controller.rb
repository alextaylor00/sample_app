class UsersController < ApplicationController

  def show
  	@this_user = User.find(params[:id])
  	#debugger
  end

  def new
  	@user = User.new # create a new user for the form to use
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # Handle a successful save.
    else
      render 'new'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end

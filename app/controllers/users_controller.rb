class UsersController < ApplicationController

  def show
  	@this_user = User.find(params[:id])
  	#debugger
  end

  def new
  	@user = User.new # create a new user for the form to use
  end
end

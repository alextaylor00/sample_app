class UsersController < ApplicationController

  before_action :logged_in_user, only: [:index, :edit, :update]
  before_action :correct_user, only: [:edit, :update]

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
  	@this_user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    
    if @user.update_attributes(user_params)
      flash[:success] = "Your information has been updated."
      redirect_to @user

    else
      render 'edit'
    end
  end

  def new
  	@user = User.new # create a new user for the form to use
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome, #{@user.name}!"
      log_in @user
      redirect_to @user      

    else
      render 'new'
    end
  end


  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # Confirms that the current user is authorized to perform the action.
    def correct_user
      @user = User.find(params[:id])

      if @user != current_user
        flash[:danger] = "You're not permitted to perform that action."
        redirect_to(root_url) unless current_user?(@user)
      end
      
    end
end

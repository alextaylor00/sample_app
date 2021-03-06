class UsersController < ApplicationController

  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
  	@user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
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
    
    if !logged_in?
      @user = User.new # create a new user for the form to use
    else
      @user = User.find(session[:user_id])
      flash[:warning] = "You've already signed up."
      redirect_to @user

    end
  	
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your e-mail to activate your account."
      redirect_to root_url

    else
      render 'new'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_path
  end



  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end


    # Confirms that the current user is authorized to perform the action.
    def correct_user
      @user = User.find(params[:id])

      if @user != current_user
        flash[:danger] = "You're not permitted to perform that action."
        redirect_to(root_url) unless current_user?(@user)
      end
    end

    # Confirms that the current user is an admin.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end

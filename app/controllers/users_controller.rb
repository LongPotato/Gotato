class UsersController < ApplicationController
  before_action :logged_in_user, except: [:new, :create]
  before_action :correct_user,   only: [:edit, :update, :show, :account_password]

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def account_password
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Password changed"
      redirect_to @user
    else
      render 'account_password'
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in(@user)
      flash[:success] = "Thank you for signing up, #{@user.name}."
      redirect_to root_path
    else
      render 'new'
    end
  end

  def show
  end


  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end

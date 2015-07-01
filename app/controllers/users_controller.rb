class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update, :show]

  def new
    @user = User.new
  end
  
  def edit
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in(@user)
      flash[:success] = "Thank you for signing up, #{@user.name}."
      redirect_to user_path(@user)
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

    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      unless current_user?(@user)
        flash[:danger] = "You don't have permission for that action."
        redirect_to(root_url)
      end
    end
end

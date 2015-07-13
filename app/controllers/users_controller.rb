class UsersController < ApplicationController
  before_action :logged_in_user, except: [:new, :create]
  before_action :correct_user_id,   only: [:edit, :update, :show, :account_password, :three_months, :all, :setting, :set_vnd]

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def three_months
    @orders = current_user.orders.three_months.order(sort_column + " " + sort_direction)
    @orders = current_user.orders.joins(:customer).three_months.status.order(sort_column + " " + sort_direction) if params[:sale].present?
    @orders = current_user.orders.joins(:customer).three_months.placed.order(sort_column + " " + sort_direction) if params[:placed].present?
  end

  def all
    @orders = current_user.orders.order(sort_column + " " + sort_direction)
    @orders = current_user.orders.joins(:customer).status.order(sort_column + " " + sort_direction) if params[:sale].present?
    @orders = current_user.orders.joins(:customer).placed.order(sort_column + " " + sort_direction) if params[:placed].present?
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

  def setting
    @user = User.find(params[:id])
  end

  def set_vnd
    @user = User.find(params[:id])
    @user.update_attributes(user_params)
    if @user.save
      flash[:success] = "Setting exchange rate has been set to #{@user.setting_vnd}"
      redirect_to setting_user_path(current_user)
    else
      flash.now[:danger] = "Unable to save setting"
      render 'setting'
    end
  end


  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :setting_vnd)
    end

    # Confirms the correct user.
    def correct_user_id
      @user = User.find(params[:id])
      unless current_user?(@user)
        flash[:danger] = "You don't have permission for that action."
        redirect_to(root_url)
      end
    end
end

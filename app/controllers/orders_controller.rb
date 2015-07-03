class OrdersController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user

  def index
    @orders =  current_user.orders.all
  end

  def show
    @order = Order.find(params[:id])
  end

  def new
    @user = current_user
    @order = Order.new
  end

  def create

  end

  private
    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:user_id])
      unless current_user?(@user)
        flash[:danger] = "You don't have permission for that action."
        redirect_to(root_url)
      end
    end
end

class OrdersController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user

  def index
    @orders =  current_user.orders.order(sort_column + " " + sort_direction)
  end

  def show
    @order = Order.find(params[:id])
  end

  def new
    @user = current_user
    @order = Order.new
    @order.build_customer
  end

  def create
    @order = Order.new(order_params)

    #Use setting vnd if user choose it
    if params[:order][:use_user_rate] == 1
      @order.vnd = @order.user.setting_vnd
    else
      @order.vnd = params[:order][:vnd]
    end
    
    if @order.save
      flash[:success] = "Created order ##{@order.id}"
      redirect_to user_orders_path(@order.user)
    else
      render 'new'
    end
  end

  def edit
    @order = Order.find(params[:id])
  end

  def update
    @order = Order.find(params[:id])

    #Use setting vnd if user choose it
    if params[:order][:use_user_rate] == '1'
      @order.update_attributes(vnd: current_user.setting_vnd)
    else
      @order.update_attributes(vnd: params[:order][:vnd])
    end

    if @order.update_attributes(order_params)
      flash[:success] = "Edited order ##{@order.id}"
      redirect_to user_orders_path(@order.user)
    else
      render 'new'
    end
  end

  def destroy
    order_id = params[:id]
    Order.find(params[:id]).destroy
    flash[:danger] = "Deleted order ##{order_id}"
    redirect_to user_orders_path(current_user)
  end

  private

    #Confirms the correct user.
    def correct_user
      @user = User.find(params[:user_id])
      unless current_user?(@user)
        flash[:danger] = "You don't have permission for that action."
        redirect_to(root_url)
      end
    end

    #White list parameters
    def order_params
      params.require(:order).permit(:user_id, :name, :quantity, :store, :image_link, :description, :note,
                                    :web_price, :tax, :reward, :shipping_us, :order_date, :receive_us, :ship_vn,
                                    :selling_price, :deposit, customer_attributes: [:name])
    end

end

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
    @order = Order.new(order_params)

    #Use setting vnd if user choose it
    if params[:order][:use_user_rate] == 1
      @order.vnd = @order.user.setting_vnd
    else
      @order.vnd = params[:order][:vnd]
    end
    
    #Assignt order to existing customer or create new one if not exist
    unless params[:order][:customer_name].empty?
      if custom = Customer.find_by(name: params[:order][:customer_name].downcase)
        @order.customer_id = custom.id
      elsif
        custom = Customer.create(name: params[:order][:customer_name])
        @order.customer_id = custom.id
      end
    end
    
    @order.order_date = Date.strptime(params[:order][:order_date], '%m/%d/%Y') unless params[:order][:order_date].empty?
    @order.receive_us = Date.strptime(params[:order][:receive_us], '%m/%d/%Y') unless params[:order][:receive_us].empty?
    @order.ship_vn = Date.strptime(params[:order][:ship_vn], '%m/%d/%Y') unless params[:order][:ship_vn].empty?

    if @order.save
      redirect_to user_orders_path(@order.user)
    else
      render 'new'
    end
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
                                    :web_price, :tax, :reward, :shipping_us,
                                    :selling_price, :deposit)
    end

end

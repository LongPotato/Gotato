class OrdersController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user

  def index
    @orders = current_user.orders.order(sort_column + " " + sort_direction)
  end

  def for_sale
    @orders = current_user.orders.joins(:customer).where('customers.name = ?', 'for sale').order(sort_column + " " + sort_direction)
  end

  def ordered
    @orders = current_user.orders.joins(:customer).where('customers.name != ?', 'for sale').order(sort_column + " " + sort_direction)
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
    if params[:order][:use_user_rate] == "1"
      @order.vnd = @order.user.setting_vnd
    else
      @order.vnd = params[:order][:vnd]
    end

    if @order.save
      @order.total = @order.calculate_total.round(2)
      @order.total_cost = @order.calculate_total_cost.round(2)
      @order.profit = @order.calculate_profit.round(2)
      @order.remain = @order.calculate_remain.round(2)
      if @order.save
        flash[:success] = "Created order ##{@order.id}"
        redirect_to user_order_path(@order.user, @order)
      else
        render 'new'
      end
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
    if params[:order][:use_user_rate] == "1"
      @order.update_attributes(vnd: current_user.setting_vnd)
    else
      @order.update_attributes(vnd: params[:order][:vnd])
    end

    if @order.update_attributes(order_params)
      @order.update_attributes(total: @order.calculate_total.round(2))
      @order.update_attributes(total_cost: @order.calculate_total_cost.round(2))
      @order.update_attributes(profit: @order.calculate_profit.round(2))
      @order.update_attributes(remain: @order.calculate_remain.round(2))
      flash[:success] = "Edited order ##{@order.id}"
      redirect_to user_order_path(@order.user, @order)
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

    #White list parameters
    def order_params
      params.require(:order).permit(:user_id, :store, :image_link, :description, :note, :web_order_id,
                                    :web_price, :tax, :reward, :shipping_us, :order_date, :received_us, :ship_vn,
                                    :selling_price, :deposit, customer_attributes: [:name])
    end

end

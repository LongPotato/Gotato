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
    if params[:order][:use_user_rate] == "1"
      @order.vnd = @order.user.setting_vnd
      choice = 1
    else
      @order.vnd = params[:order][:vnd]
      choice = 0
    end

    @order.total = calculate_total.round(2)
    @order.total_cost = calculate_total_cost.round(2)
    @order.profit = calculate_profit(choice).round(2)
    
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
    if params[:order][:use_user_rate] == "1"
      @order.update_attributes(vnd: current_user.setting_vnd)
      choice = 1
    else
      @order.update_attributes(vnd: params[:order][:vnd])
      choice = 0
    end

    @order.update_attributes(total: calculate_total.round(2))
    @order.update_attributes(total_cost: calculate_total_cost.round(2))
    @order.update_attributes(profit: calculate_profit(choice).round(2))

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


    def calculate_total
      total = (params[:order][:web_price].to_f + params[:order][:tax].to_f + params[:order][:shipping_us].to_f - params[:order][:reward].to_f)
    end

    def calculate_total_cost
      unless @order.shipping_vn.nil?
        calculate_total + @order.shipping_vn
      else
        calculate_total
      end
    end

    def calculate_profit(choice)
      if choice == 1
        @order.selling_price - (calculate_total_cost * @order.user.setting_vnd)
      else
        @order.selling_price - (calculate_total_cost * params[:order][:vnd])
      end
    end

end

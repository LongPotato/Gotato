class OrdersController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user

  def index
    @orders = current_user.orders.this_month.order(sort_column + " " + sort_direction)

    if params[:sale].present?
      sale = current_user.orders.joins(:customer).this_month.status
      if params[:received].present?
        @orders = sale.received.order(sort_column + " " + sort_direction)
      elsif params[:not].present?
        @orders = sale.not_received.order(sort_column + " " + sort_direction)
      else
        @orders = sale.order(sort_column + " " + sort_direction)
      end
    elsif params[:placed].present?
      placed = current_user.orders.joins(:customer).this_month.placed
      if params[:received].present?
        @orders = placed.received.order(sort_column + " " + sort_direction)
      elsif params[:not].present?
        @orders = placed.not_received.order(sort_column + " " + sort_direction)
      else
        @orders = placed.order(sort_column + " " + sort_direction)
      end
    else
      if params[:received].present?
        @orders = current_user.orders.this_month.received.order(sort_column + " " + sort_direction)
      end
      if params[:not].present?
        @orders = current_user.orders.this_month.not_received.order(sort_column + " " + sort_direction)
      end
    end
    
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
    cus_name = params[:order][:customer_attributes][:name]

    if customer = Customer.find_by_name(cus_name.downcase)
      @order.customer_id = customer.id
    else
      @order.save
      @order.update_attributes(customer_attributes: {name: cus_name, user_id: current_user.id})
    end
       
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
    cus_name = params[:order][:customer_attributes][:name]

    if customer = Customer.find_by_name(cus_name.downcase)
      @order.update_attributes(customer_id: customer.id)
    else
      @order.update_attributes(customer_attributes: {name: cus_name, user_id: current_user.id})
    end

    #Use setting vnd if user choose it
    if params[:order][:use_user_rate] == "1"
      @order.update_attributes(vnd: current_user.setting_vnd)
    else
      @order.update_attributes(vnd: params[:order][:vnd])
    end

    #If user enter shipping_id, recalculate shipping price for each order then update the database
    if params[:order][:shipping_id].present?
      ship_id = params[:order][:shipping_id]
      if shipment = current_user.shippings.find_by_id(ship_id)
        item_price = shipment.calculate_ship_vn.round(2)
        @order.update_attributes(shipping_id: ship_id)
        shipment.orders.each do |order|
          order.update_attributes(shipping_vn: item_price)
          order.update_attributes(total_cost: order.calculate_total_cost.round(2))
          order.update_attributes(profit: order.calculate_profit.round(2))
        end
        order_id = shipment.order_fields.split(',')
        order_id << @order.id
        shipment.update_attributes(order_fields: order_id.join(','))
      else
        flash[:danger] = "Shipment ##{ship_id} does not exist"
        render 'edit'
        return
      end
    end

    if @order.update_attributes(order_params)
      @order.update_attributes(total: @order.calculate_total.round(2))
      @order.update_attributes(total_cost: @order.calculate_total_cost.round(2))
      @order.update_attributes(profit: @order.calculate_profit.round(2))
      @order.update_attributes(remain: @order.calculate_remain.round(2))
      flash[:success] = "Edited order ##{@order.id}"
      redirect_to user_order_path(@order.user, @order)
    else
      render 'edit'
    end
  end

  def destroy
    order_id = params[:id]
    Order.find(params[:id]).destroy
    flash[:danger] = "Deleted order ##{order_id}"
    redirect_to user_orders_path(current_user)
  end

  def remove
    @order = Order.find(params[:order_id])
    ship_id = @order.shipping_id
    @order.update_attributes(shipping_id: nil, ship_vn: nil, shipping_vn: 0)
    @order.update_attributes(total_cost: @order.calculate_total_cost.round(2))
    @order.update_attributes(profit: @order.calculate_profit.round(2))
    @shipment = Shipping.find(ship_id)
    @shipment.update_attributes(order_fields: @shipment.order_fields.gsub(/#{@order.id}/, ""))
    @orders = Order.where(shipping_id: ship_id)
    @orders.each do |order|
      order.update_attributes(shipping_vn: @shipment.calculate_ship_vn.round(2))
      order.update_attributes(total_cost: order.calculate_total_cost.round(2))
      order.update_attributes(profit: order.calculate_profit.round(2))
    end
    flash[:warning] = "Removed order ##{@order.id} from shipment ##{ship_id}"
    redirect_to user_shipping_path(current_user, ship_id)
  end

  private

    #White list parameters
    def order_params
      params.require(:order).permit(:user_id, :store, :image_link, :description, :note, :web_order_id,
                                    :web_price, :tax, :reward, :shipping_us, :shipping_vn, :order_date, :received_us, :ship_vn,
                                    :selling_price, :deposit, :remove_image_link)
    end

end

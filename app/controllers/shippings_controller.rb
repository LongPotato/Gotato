class ShippingsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user

  def index
    @shipments = current_user.shippings.order(sort_column + " " + sort_direction).uniq
  end

  def new
    @shipment = Shipping.new
    @user = current_user
  end

  def create
    @shipment = Shipping.new(shipment_params)
    @shipment.order_fields = params[:shipping][:order_fields]
    @order_ids = params[:shipping][:order_fields].gsub(/\s+/, "").split(',')

    if @shipment.save
      @valid_order = []
      order_id = []

      @order_ids.each do |id|
        @order = Order.find_by_id(id)
        unless @order.nil?
          @valid_order << @order
          order_id << @order.id
          @shipment.update_attributes(order_fields: order_id.join(','))
          @order.update_attributes(ship_vn: @shipment.ship_date, shipping_id: @shipment.id)
        end
      end

      @valid_order.each do |order|
        item_price = @shipment.calculate_ship_vn.round(2)
        order.update_attributes(shipping_vn: item_price)
        order.update_attributes(total_cost: order.calculate_total_cost.round(2))
        order.update_attributes(profit: order.calculate_profit.round(2))
      end
      
      flash[:success] = "Created new shipment, ship ID: #{@shipment.id}"
      redirect_to user_shipping_path(current_user, @shipment.id)
    else
      render 'new'
    end
  end

  def show
    @shipment = Shipping.find(params[:id])
  end

  def edit
    @shipment = Shipping.find(params[:id])
  end


  def update
    @shipment = Shipping.find(params[:id])
    @order_ids = params[:shipping][:order_fields].gsub(/\s+/, "").split(',')

    if @shipment.update_attributes(shipment_params)
      @valid_order = []
      order_id = []
      old_orders = @shipment.order_fields.split(',')
      old_orders.map! { |a| a.to_i }

      @order_ids.each do |id|
        @order = Order.find_by_id(id)
        unless @order.nil?
          @valid_order << @order
          order_id << @order.id
          @shipment.update_attributes(order_fields: order_id.join(','))
          @order.update_attributes(ship_vn: @shipment.ship_date, shipping_id: @shipment.id)
        end
      end

      removed_orders = old_orders - order_id

      removed_orders.each do |id|
        order = Order.find_by_id(id)
        unless order.nil?
          order.update_attributes(shipping_vn: 0, ship_vn: nil, shipping_id: nil)
          order.update_attributes(total_cost: order.calculate_total_cost.round(2))
          order.update_attributes(profit: order.calculate_profit.round(2))
        end
      end

      @valid_order.each do |order|
        item_price = @shipment.calculate_ship_vn.round(2)
        order.update_attributes(shipping_vn: item_price)
        order.update_attributes(total_cost: order.calculate_total_cost.round(2))
        order.update_attributes(profit: order.calculate_profit.round(2))
      end
      
      flash[:success] = "Edited shipment ##{@shipment.id}"
      redirect_to user_shipping_path(current_user, @shipment.id)
    else
      render 'edit'
    end
  end

  def destroy
    ship_id = params[:id]
    orders = Order.where(shipping_id: ship_id)
    orders.each do |order|
      order.update_attributes(shipping_vn: 0, shipping_id: nil, ship_vn: nil)
    end
    Shipping.find(ship_id).destroy
    flash[:danger] = "Deleted shipment ##{params[:id]}"
    redirect_to user_shippings_path(current_user)
  end

  private

    def shipment_params
      params.require(:shipping).permit(:description, :ship_date, :price)
    end

    
end
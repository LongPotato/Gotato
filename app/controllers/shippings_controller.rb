class ShippingsController < ApplicationController

  before_action :logged_in_user
  before_action :correct_user

  def index
    @shipments = current_user.shippings.this_month.uniq.order(sort_column + " " + sort_direction)
  end

  def lookup_range
    if params[:time].present?
      @@time = params[:time].split(' - ')
      @from = @@time.first
      @to = @@time.second
      @shipments = current_user.shippings.where("ship_date BETWEEN ? AND ?", @from, @to).uniq.order(sort_column + " " + sort_direction)
    else
      @shipments = []
    end
  end

  def all
    @shipments = current_user.shippings.order(sort_column + " " + sort_direction).uniq
  end

  def lookup_shipment
    @shipment = current_user.shippings.find_by(id: params[:id])
    if @shipment
      redirect_to user_shipping_path(current_user, @shipment)
    else
      flash[:danger] = "Shipment ##{params[:id]} not found"
      redirect_to user_shippings_path(current_user)
    end
  end

  def new
    @shipment = Shipping.new
    @user = current_user
    authorize! :update, Shipping
  end

  def create
    @shipment = Shipping.new(shipment_params)
    @shipment.order_fields = params[:shipping][:order_fields]
    @shipment.users << current_user unless @shipment.users.find_by_id(current_user.id)
    @order_ids = params[:shipping][:order_fields].gsub(/\s+/, "").split(',')

    if current_user.role == "manager"
      if current_user.seller.present?
        @shipment.users << current_user.seller unless @shipment.users.find_by_id(current_user.seller.id)
      end
    else
      if current_user.manager.present?
        @shipment.users << current_user.manager unless @shipment.users.find_by_id(current_user.manager.id)
      end
    end

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
      
      flash[:success] = "Created new shipment, ship ID: #{@shipment.id}."
      redirect_to user_shipping_path(current_user, @shipment.id)
    else
      render 'new'
    end

    authorize! :create, Shipping
  end

  def show
    @shipment = Shipping.find(params[:id])
    @orders = @shipment.orders.order(sort_column + " " + sort_direction)
  end

  def edit
    @shipment = Shipping.find(params[:id])
  end


  def update
    @shipment = Shipping.find(params[:id])
    @shipment.users << current_user unless @shipment.users.find_by_id(current_user.id)
    @order_ids = params[:shipping][:order_fields].gsub(/\s+/, "").split(',')

    if current_user.role == "manager"
      if current_user.seller.present?
        @shipment.users << current_user.seller unless @shipment.users.find_by_id(current_user.seller.id)
      end
    else
      if current_user.manager.present?
        @shipment.users << current_user.manager unless @shipment.users.find_by_id(current_user.manager.id)
      end
    end

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
      
      flash[:success] = "Edited shipment ##{@shipment.id}."
      redirect_to user_shipping_path(current_user, @shipment.id)
    else
      render 'edit'
    end

  end

  def destroy
    url = Rails.application.routes.recognize_path(request.referrer)  #Convert the previous url into a hash of controller and action
    store_location

    ship_id = params[:id]
    orders = Order.where(shipping_id: ship_id)
    orders.each do |order|
      order.update_attributes(shipping_vn: 0, shipping_id: nil, ship_vn: nil)
      order.update_attributes(total_cost: order.calculate_total_cost.round(2))
      order.update_attributes(profit: order.calculate_profit.round(2))
    end
    Shipping.find(ship_id).destroy
    flash[:danger] = "Deleted shipment ##{params[:id]}."
    redirect_back_or(user_shippings_path(current_user), url[:controller], url[:action])
  end

  def quick_add
    @orders = current_user.orders.where("ship_vn" => nil).received.uniq.order(sort_column + " " + sort_direction)
    authorize! :update, Shipping
  end

  def update_quick_add
    @shipment = Shipping.new(shipment_params)
    if params[:order_ids]
      @orders = params[:order_ids]
      @shipment.users << current_user unless @shipment.users.find_by_id(current_user.id)

      if current_user.role == "manager"
        if current_user.seller.present?
          @shipment.users << current_user.seller unless @shipment.users.find_by_id(current_user.seller.id)
        end
      else
        if current_user.manager.present?
          @shipment.users << current_user.manager unless @shipment.users.find_by_id(current_user.manager.id)
        end
      end

      @shipment.order_fields = @orders.join(',')
      @valid_order = []
    else
      flash[:danger] = "Unable to create new shipment, please select at least 1 order."
      redirect_to user_shippings_path(current_user)
      return
    end

    if @shipment.save
      @orders.each do |id|
        order = Order.find_by_id(id)
        order.update_attributes(ship_vn: @shipment.ship_date, shipping_id: @shipment.id)
        @valid_order << order
      end

      item_price = @shipment.calculate_ship_vn.round(2)

      @valid_order.each do |order|
        order.update_attributes(shipping_vn: item_price)
        order.update_attributes(total_cost: order.calculate_total_cost.round(2))
        order.update_attributes(profit: order.calculate_profit.round(2))
      end

      flash[:success] = "Created new shipment, ship ID: #{@shipment.id}."
      redirect_to user_shipping_path(current_user, @shipment.id)
    else
      flash[:danger] = "Unable to create new shipment: #{@shipment.errors.full_messages}."
      redirect_to user_shippings_path(current_user)
    end
    authorize! :update, Shipping
  end

  private

    def shipment_params
      params.require(:shipping).permit(:description, :ship_date, :price)
    end
    
end

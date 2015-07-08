class ShippingsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user

  def index
    @shipments = current_user.shippings.uniq
  end

  def new
    @shipment = Shipping.new
    @user = current_user
  end

  def create
    @shipment = Shipping.new(shipment_params)
    @order_ids = params[:shipping][:order_fields].gsub(/\s+/, "").split(',')

    if @shipment.save
      @valid_order = []

      @order_ids.each do |id|
        @order = Order.find_by_id(id)
        unless @order.nil?
          @valid_order << @order
          @order.update_attributes(ship_vn: @shipment.ship_date, shipping_id: @shipment.id)
        end
      end

      @valid_order.each do |order|
        item_price = calculate_ship_vn.round(2)
        order.update_attributes(shipping_vn: item_price)
      end
      
      flash[:success] = "Created new shipment, ship ID: #{@shipment.id}"
      redirect_to user_shippings_path(current_user)
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

      @order_ids.each do |id|
        @order = Order.find_by_id(id)
        unless @order.nil?
          @valid_order << @order
          @order.update_attributes(ship_vn: @shipment.ship_date, shipping_id: @shipment.id)
        end
      end

      @valid_order.each do |order|
        item_price = calculate_ship_vn.round(2)
        order.update_attributes(shipping_vn: item_price)
      end
      
      flash[:success] = "Edit shipment ##{@shipment.id}"
      redirect_to user_shippings_path(current_user)
    else
      render 'edit'
    end
  end

  def destroy
    Shipping.find(params[:id]).destroy
    flash[:danger] = "Deleted shipment ##{params[:id]}"
    redirect_to user_shippings_path(current_user)
  end

  private

    def shipment_params
      params.require(:shipping).permit(:description, :ship_date, :price, :order_fields)
    end

    def calculate_ship_vn
      @shipment.price / @valid_order.count
    end

end

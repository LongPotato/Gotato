class DataController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user

  def show
    @this_month = current_user.data.find(params[:id])
    time = @this_month.month_record
    @shipment = current_user.shippings.where("ship_date BETWEEN ? AND ?", time.beginning_of_month, time.end_of_month).uniq
    unless @this_month.nil?
      @received = @this_month.orders.received.count
      @for_sale = @this_month.orders.joins(:customer).sale.count
      @shipped = @this_month.orders.where.not("ship_vn" => nil).count
      @total_shipping = @shipment.map(&:price).sum.to_f unless @shipment.nil?
      @total_reward = @this_month.orders.map(&:reward).sum.to_f

      @order_sold = @this_month.order_sold
      @revenue = @this_month.revenue.to_f.round
      @total_selling = @this_month.total_selling.to_f
      @total_cost = @this_month.total_cost.to_f
    else
      @revenue = 0
      @total_selling = 0
      @total_cost = 0
    end
  end
end

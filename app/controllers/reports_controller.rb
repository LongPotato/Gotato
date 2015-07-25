class ReportsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user

  def show_report
    @this_month = current_user.data.where("month_record BETWEEN ? AND ?", Time.now.beginning_of_month, Time.now.end_of_month).first
    @shipment = current_user.shippings.where("ship_date BETWEEN ? AND ?", Time.now.beginning_of_month, Time.now.end_of_month).uniq
    unless @this_month.nil?
      @received = @this_month.orders.received.count
      @for_sale = @this_month.orders.joins(:customer).status.count
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

  def monthly_index
    @reports = current_user.data.order("month_record desc")
  end

  def show_year
    @this_year = current_user.data.where("month_record BETWEEN ? AND ?", Time.now.beginning_of_year, Time.now.end_of_year).order("month_record desc")
    @shipment = current_user.shippings.where("ship_date BETWEEN ? AND ?", Time.now.beginning_of_year, Time.now.end_of_year).uniq
    unless @this_year.nil?
      @reports = @this_year
      @total_cost = @this_year.map(&:total_cost).sum.to_f.round(2)
      @total_selling = @this_year.map(&:total_selling).sum.to_f.round(2)
      @profit = (@total_selling - @total_cost).round(2)
      orders = get_batch_orders(@this_year)
      @total_shipping = @shipment.map(&:price).sum.to_f.round(2) unless @shipment.nil?
      @total_reward = orders.map(&:reward).sum.to_f.round(2)
    end
  end

  def generate_report
    @orders_by_month = current_user.orders.all.group_by { |order| order.order_date.beginning_of_month }
    
    @orders_by_month.each do |month, orders|
      if current_user.data.where("extract(year from month_record) = ?", month.strftime('%Y').to_i).present?
        this_year = current_user.data.where("extract(year from month_record) = ?", month.strftime('%Y').to_i)
        if this_year.where("extract(month from month_record) = ?", month.strftime('%m').to_i).present?
          @report = this_year.where("extract(month from month_record) = ?", month.strftime('%m').to_i).first
        else
          @report = Datum.new
        end
      else
        @report = Datum.new
      end
      vnd = orders.first.vnd.to_f
      total_cost = (orders.map(&:total_cost).sum.to_f / vnd).round(2)
      selling = (orders.map(&:selling_price).sum.to_f / vnd).round(2)
      count = orders.count

      @report.month_record = month
      @report.total_cost = total_cost
      @report.total_selling = selling
      @report.revenue = (selling - total_cost).round(2)
      @report.order_sold = count
      @report.user_id = current_user.id

      @report.save

      orders.each do |order|
        order.update_attributes(datum_id: @report.id)
      end

      check_valid_data
    end

    redirect_to user_report_path(current_user)
  end

  private

    def check_valid_data
      data = current_user.data
      data.each do |datum|
        if datum.orders.empty?
          datum.destroy
        end
      end
    end

    def get_batch_orders(this_year)
      orders = []
      this_year.each do |datum|
        orders << datum.orders
      end
      return orders.flatten
    end

end

class ReportsController < ApplicationController
  def show_report
    @reports = current_user.data
  end

  def generate_report
    @orders_by_month = current_user.orders.all.group_by { |order| order.created_at.beginning_of_month }
    
    @orders_by_month.each do |month, orders|
      @report = Datum.new
      vnd = orders.first.vnd.to_f
      total_cost = orders.map(&:total_cost).sum / vnd
      selling = orders.map(&:selling_price).sum / vnd
      count = orders.count

      orders.each do |order|
        @report.month_record = order.order_date
        @report.total_cost = total_cost.round(2)
        @report.total_selling = selling.round(2)
        @report.revenue = selling - total_cost
        @report.order_sold = count
        @report.user_id = current_user.id
      end

      @report.save

    end

    redirect_to user_report_path(current_user)
  end
end

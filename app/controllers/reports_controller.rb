class ReportsController < ApplicationController
  def show_report
    @reports = current_user.data.order("month_record desc")
  end

  def generate_report
    @orders_by_month = current_user.orders.all.group_by { |order| order.order_date.beginning_of_month }
    
    @orders_by_month.each do |month, orders|
      if current_user.data.where("strftime('%m', month_record) + 0 = ?", month.strftime('%m').to_i).present?
        @report = current_user.data.where("strftime('%m', month_record) + 0 = ?", month.strftime('%m').to_i).first
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
    end

    redirect_to user_report_path(current_user)
  end
end

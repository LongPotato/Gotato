class StaticPagesController < ApplicationController

  def home
    if current_user
      array_id = []
      array_id << current_user.id
      if current_user.role == "manager"
        array_id << current_user.seller.id if current_user.seller.present?
      else
        array_id << current_user.manager.id if current_user.manager.present?
      end
      @activities = PublicActivity::Activity.order("created_at desc").where(owner_id: array_id).limit(10).uniq
      @this_month = current_user.data.where("month_record BETWEEN ? AND ?", Time.now.beginning_of_month, Time.now.end_of_month).first
      @user = current_user
      @requests = current_user.requests.where(check: false).count
      @messages = current_user.messages.where("messages.user_id != ?", current_user.id).where(read: false).count
      unless @this_month.nil?
        completed = @this_month.orders.where.not("ship_vn" => nil).received.count
        total = @this_month.order_sold
        received = @this_month.orders.where("ship_vn" => nil).received.count

        @total_display = total
        @completed_display = completed
        @pending_display = received
        @remaining_display = total - completed - received

        @completed = ((completed.to_f / total) * 100)
        @received = ((received.to_f / total) * 100)
        @not_received = 100 - @completed - @received
      end
    end
  end

end

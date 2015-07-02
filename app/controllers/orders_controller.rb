class OrdersController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user

  def index
    @orders =  current_user.orders.all
  end

end

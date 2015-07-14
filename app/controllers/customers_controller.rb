class CustomersController < ApplicationController

  def index
    @customers = current_user.customers.search(params[:search])
  end

  def show
    @customer = Customer.find(params[:id])
    @orders = @customer.orders.order(sort_column + " " + sort_direction)
  end

end

class CustomersController < ApplicationController

  def index
    @customers = current_user.customers
  end

  def show
    @customer = Customer.find(params[:id])
  end

end

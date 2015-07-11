class CustomersController < ApplicationController

  def index
    @customers = current_user.customers.search(params[:search])
  end

  def show
    @customer = Customer.find(params[:id])
  end

end

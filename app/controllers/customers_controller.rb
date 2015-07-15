class CustomersController < ApplicationController

  def index
    @customers = current_user.customers.search(params[:search])
  end

  def show
    @customer = Customer.find(params[:id])
    @orders = @customer.orders.order(sort_column + " " + sort_direction)
  end

  def edit
    @customer = Customer.find(params[:id])
    @user = current_user
  end

  def update
    @customer = Customer.find(params[:id])
    if @customer.update_attributes(customer_params)
      flash[:success] = "Updated customer #{@customer.name.titleize}'s info"
      redirect_to user_customer_path(current_user, @customer.id)
    else
      render 'edit'
    end
  end

  private
  
    def customer_params
      params.require(:customer).permit(:address, :bank)
    end

end

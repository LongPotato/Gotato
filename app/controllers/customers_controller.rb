class CustomersController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user

  def index
    @customers = current_user.customers.search(params[:search]).uniq.order("name asc")
  end

  def show
    @customer = current_user.customers.find(params[:id])
    @orders = @customer.orders.order(sort_column + " " + sort_direction)
  end

  def edit
    @customer = current_user.customers.find(params[:id])
    @user = current_user
  end

  def update
    @customer = current_user.customers.find(params[:id])
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

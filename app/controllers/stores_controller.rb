class StoresController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user

  def index
    @stores = current_user.stores.search(params[:search]).order("name asc")
  end

  def show
    @store = current_user.stores.find(params[:id])
    @orders = @store.orders.order(sort_column + " " + sort_direction)
  end

  def edit
    @store = current_user.stores.find(params[:id])
    @user = current_user
  end

  def update
    @store = current_user.stores.find(params[:id])
    if @store.update_attributes(store_params)
      flash[:success] = "Updated info for #{@store.name.titleize}."
      redirect_to user_store_path(current_user, @store.id)
    else
      render 'edit'
    end
  end

  private
  
    def store_params
      params.require(:store).permit(:note)
    end


end

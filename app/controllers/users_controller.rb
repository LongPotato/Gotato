class UsersController < ApplicationController
  before_action :logged_in_user, except: [:new, :create]
  before_action :correct_user_id,   only: [:edit, :update, :show, :account_password, :three_months, :all, :setting, :set_vnd]

  has_scope :sale, :type => :boolean
  has_scope :placed, :type => :boolean
  has_scope :received, :type => :boolean
  has_scope :not, :type => :boolean

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def all
    @orders = apply_scopes(current_user.orders).order(sort_column + " " + sort_direction).uniq

    respond_to do |format|
      format.html
      format.csv do
      headers['Content-Disposition'] = "attachment; filename=\"all_orders\""
      headers['Content-Type'] ||= 'text/csv'
      end
    end
  end

  def account_password
    @user = User.find(params[:id])
  end

  def set_note
    @user = User.find(params[:id])
    @user.update_attributes(note: params[:user][:note])
    redirect_to root_path
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Password changed"
      redirect_to @user
    else
      render 'account_password'
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in(@user)
      flash[:info] = "Thank you for signing up, #{@user.name}."
      redirect_to root_path
    else
      render 'new'
    end
  end

  def setting
    @user = User.find(params[:id])
  end

=begin
  def set_vnd
    @user = User.find(params[:id])
    @user.update_attributes(user_params)
    if @user.save
      flash[:success] = "Setting exchange rate has been set to #{@user.setting_vnd}"
      redirect_to setting_user_path(current_user)
    else
      flash.now[:danger] = "Unable to save setting"
      render 'setting'
    end
  end
=end

  def set_vnd
    @user = User.find(params[:id])
    #User.update_rate
    @user.update_vnd
    flash[:success] = "Setting exchange rate has been set to #{@user.setting_vnd}"
    redirect_to setting_user_path(current_user)
  end

  def remove_seller
    @user = User.find(params[:id])

    #Remove seller from all resources
    @user.orders.each do |order|
      order.users.delete(@user.seller)
    end

    @user.customers.each do |customer|
      customer.users.delete(@user.seller)
    end

    @user.stores.each do |store|
      store.users.delete(@user.seller)
    end

    @user.data.each do |datum|
      datum.users.delete(@user.seller)
    end

    @user.shippings.each do |shipping|
      shipping.users.delete(@user.seller)
    end

    @user.seller.update_attributes(manager_id: nil)
    flash[:warning] = "You are no longer sharing data with #{@user.seller.name.titleize}."
    redirect_to user_path(current_user)
  end

  def add_seller
    @user = User.where("email = ? AND role = ?", params[:email], "seller").first
    if @user
      @user.update_attributes(manager_id: params[:id])
      
      #Add seller to all resources
      current_user.orders.each do |order|
        order.users << current_user.seller
      end

      current_user.customers.each do |customer|
        customer.users << current_user.seller
      end

      current_user.stores.each do |store|
        store.users << current_user.seller
      end

      current_user.data.each do |datum|
        datum.users << current_user.seller
      end

      current_user.shippings.each do |shipping|
        shipping.users << current_user.seller
      end

      flash[:success] = "You are now sharing data with your seller: #{@user.name.capitalize}."
      redirect_to user_path(current_user)
    else
      flash[:danger] = "Seller email not found."
      redirect_to user_path(current_user)
    end
  end

  def remove_manager
    @user = User.find(params[:id])
    manager = @user.manager

    #Remove self from all resources
    @user.orders.each do |order|
      order.users.delete(@user)
    end

    @user.customers.each do |customer|
      customer.users.delete(@user)
    end

    @user.stores.each do |store|
      store.users.delete(@user)
    end

    @user.data.each do |datum|
      datum.users.delete(@user)
    end

    @user.shippings.each do |shipping|
      shipping.users.delete(@user)
    end

    @user.update_attributes(manager_id: nil)
    flash[:warning] = "You are no longer sharing data with #{manager.name.titleize}."
    redirect_to user_path(current_user)
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :setting_vnd, :role)
    end

    # Confirms the correct user.
    def correct_user_id
      @user = User.find(params[:id])
      unless current_user?(@user)
        flash[:danger] = "You don't have permission for that action."
        redirect_to(root_url)
      end
    end
end

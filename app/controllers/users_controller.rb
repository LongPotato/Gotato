class UsersController < ApplicationController
  before_action :logged_in_user, except: [:new, :create]
  before_action :correct_user_id,   only: [:edit, :update, :show, :account_password, :three_months, :all, :setting, :set_vnd]

  has_scope :sale, :type => :boolean
  has_scope :placed, :type => :boolean
  has_scope :received, :type => :boolean
  has_scope :not, :type => :boolean
  has_scope :remaining, :type => :boolean

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

  def search
    @search_term = params[:search]
    @results = []
    if is_number? @search_term
      @order = current_user.orders.find_by_id(@search_term.to_i)
      @results << @order if @order
      @shipment = current_user.shippings.find_by_id(@search_term.to_i)
      @results << @shipment if @shipment
    elsif @search_term.blank?
      @results = []
    elsif @search_term.start_with?("#")
      web_order = @search_term.gsub("#","").strip
      @orders = current_user.orders.where("web_order_id = ? ", web_order)
      @results = @results + @orders if @orders
    elsif @search_term.start_with?("%")
      num_search = @search_term.gsub("%","").strip
      @orders = current_user.orders.search(num_search)
      @results = @results + @orders if @orders
      @customers = current_user.customers.search(num_search)
      @results = @results + @customers if @customers
      @stores = current_user.stores.search(num_search)
      @results = @results + @stores if @stores
    elsif @search_term.strip == "order"
      redirect_to user_orders_path(current_user)
    elsif @search_term.strip == "new"
      redirect_to new_user_order_path(current_user)
    elsif @search_term.strip == "quick"
      redirect_to quick_add_user_shippings_path(current_user)
    elsif @search_term.strip == "shipment"
      redirect_to user_shippings_path(current_user)
    elsif @search_term.strip == "customer"
      redirect_to user_customers_path(current_user)
    elsif @search_term.strip == "store"
      redirect_to user_stores_path(current_user)
    elsif @search_term.strip == "report"
      redirect_to user_report_path(current_user)
    elsif @search_term.strip == "activity"
      redirect_to user_activities_path(current_user)
    elsif @search_term.strip == "account"
      redirect_to user_path(current_user)
    elsif @search_term.strip == "setting"
      redirect_to setting_user_path(current_user)
    elsif @search_term.strip == "request"
      redirect_to user_inbox_path(current_user)
    else
      @orders = current_user.orders.search(@search_term)
      @results = @results + @orders if @orders
      @customers = current_user.customers.search(@search_term)
      @results = @results + @customers if @customers
      @stores = current_user.stores.search(@search_term)
      @results = @results + @stores if @stores
    end
    @count = @results.count
    @results = @results.paginate(:page => params[:page], :per_page => 15)
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

    @user.requests.each do |request|
      request.destroy
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

      current_user.seller.requests.each do |request|
        request.users << current_user
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

    @user.requests.each do |request|
      request.destroy
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

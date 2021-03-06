class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include PublicActivity::StoreController
  require 'csv'
  require 'will_paginate/array'
  protect_from_forgery with: :exception
  include ApplicationHelper
  include SessionsHelper
  include OrdersHelper
  include StaticPagesHelper

  # Confirms a logged-in user.
  def logged_in_user
    unless logged_in?
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

   #Confirms the correct user.
  def correct_user
    @user = User.find(params[:user_id])
    unless current_user?(@user)
      flash[:danger] = "You don't have permission for that action."
      redirect_to(root_url)
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:danger] = "Access denied."
    redirect_to root_url
  end
    
end

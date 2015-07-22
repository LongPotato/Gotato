class DataController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user

  def show
    @report = Datum.find(params[:id])
    @orders = current_user.data.find(params[:id]).orders.order(sort_column + " " + sort_direction)
  end
end

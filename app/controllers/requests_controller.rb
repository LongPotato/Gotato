class RequestsController < ApplicationController
  before_action :logged_in_user

  def completed
    @requests = current_user.requests.where(check: true).order("id desc").paginate(:page => params[:page], :per_page => 6)
    @pending = current_user.requests.where(check: false).count
  end

  def create
    @request = Request.create(url: params[:url], note: params[:note])

    @request.users << current_user unless @request.users.find_by_id(current_user.id)

    #Add users to request
    if current_user.role == "manager"
      if current_user.seller.present?
        @request.users << current_user.seller unless @request.users.find_by_id(current_user.seller.id)
      end
    else
      if current_user.manager.present?
        @request.users << current_user.manager unless @request.users.find_by_id(current_user.manager.id)
      end
    end

    if @request.save
      redirect_to user_inbox_path(current_user)
    else
      flash[:danger] = "Unable to create request."
      redirect_to user_inbox_path(current_user)
    end
  end

  def perform_request
    if params[:request_ids]
      if params[:commit] == "Mark as Completed"
        ids = params[:request_ids]
        ids.each do |id|
          @request = Request.find(id.to_i)
          @request.update_attributes(check: true)
          @request.create_activity :update, owner: current_user
        end
        redirect_to user_inbox_path(current_user)
      elsif params[:commit] == "Mark as not Completed"
        ids = params[:request_ids]
        ids.each do |id|
          @request = Request.find(id.to_i)
          @request.update_attributes(check: false)
          @request.create_activity :uncheck, owner: current_user
        end
        redirect_to completed_user_requests_path(current_user)
      elsif params[:commit] == "Delete"
        url = Rails.application.routes.recognize_path(request.referrer)  #Convert the previous url into a hash of controller and action
        store_location
        Request.destroy(params[:request_ids])
        redirect_back_or(user_inbox_path(current_user), url[:controller], url[:action])
      end
    else
      flash[:danger] = "Select at least one request to perform the action."
      redirect_to user_inbox_path(current_user)
    end
  end

  def destroy
    @request = Request.find(params[:id])
    @request.destroy
    flash[:danger] = "Request deleted."
    redirect_to user_inbox_path(current_user)
  end

end

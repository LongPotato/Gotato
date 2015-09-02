class InboxesController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user

  def requests
    @requests = current_user.requests.where(check: false).order("id desc").paginate(:page => params[:page], :per_page => 6)
    @messages = current_user.messages.where("messages.user_id != ?", current_user.id).where(read: false)
  end

end

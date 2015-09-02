class MessagesController < ApplicationController

  def index
    @message_new = Message.new
    @messages = current_user.messages
    @requests = current_user.requests.where(check: false)
    if @messages.last
      @messages.each do |message|
        if message.user_id != current_user.id
          message.update_attributes(read: true)
        end
      end
    end
    @path = user_messages_path(current_user)
  end

  def create
    @message = Message.create!(message_params)
    if current_user.role == "manager" && current_user.seller.present?
      associate_id = current_user.seller
    elsif current_user.role == "seller" && current_user.manager.present?
      associate_id = current_user.manager
    end
    @message.update_attributes(user_id: current_user.id)
    @message.users << [current_user, associate_id]
  end

  private

  def message_params
    params.require(:message).permit(:body)
  end

end

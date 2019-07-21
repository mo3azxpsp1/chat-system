class ChatsController < ApplicationController
  before_action :set_application
  before_action :set_application_chat, only: [:show, :destroy]

  # GET /applications/:application_token/chats
  def index
    json_response(@application.chats)
  end

  # POST /applications/:application_token/chats
  def create
    chat = @application.chats.new
    chat.number = (@application.chats.maximum(:number)).to_i + 1
    chat.number += 1 until chat.valid?(:new)
    ChatCreateWorker.perform_async(chat.number, @application.id)
    json_response({chat_number: chat.number}, :created)
  end

  # GET /applications/:application_token/chats/:number
  def show
    if @chat.present?
      json_response(@chat)
    else
      json_response({message: 'Not found'}, 404)
    end
  end

  # DELETE /applications/:application_token/chats/:number
  def destroy
    @chat.destroy
    json_response({message: 'Chat deleted successfully!'}, :deleted)
  end

  private

  def set_application
    @application = Application.find_by_token(params[:application_id])
  end

  def set_application_chat
    @chat = @application.chats.find_by_number(params[:id]) if @application.present?
  end

end

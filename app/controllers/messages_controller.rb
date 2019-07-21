class MessagesController < ApplicationController

  before_action :set_application, :set_application_chat
  before_action :set_chat_message, only: [:show, :update, :destroy]

  # GET /applications/:application_token/chats/:chat_number/messages?q=
  def index
    if params[:q].present?
      messages = @chat.messages.search(params[:q]).records
    else
      messages = @chat.messages
    end
    json_response(messages)
  end

  # POST /applications/:application_token/chats/:chat_number/messages
  def create
    message = @chat.messages.new(message_params)
    message.number = (@chat.messages.maximum(:number)).to_i + 1
    message.number += 1 until message.valid?(:new)
    MessageCreateWorker.perform_async(message.number, @chat.id, params[:body])
    json_response({message_number: message.number}, :created)
  end

  # GET /applications/:application_token/chats/:chat_number/messages/:number
  def show
    if @message.present?
      json_response(@message)
    else
      json_response({message: 'Not found'})
    end
  end

  # PUT /applications/:application_token/chats/:chat_number/messages/:number
  def update
    @message.update(message_params)
    json_response(@message, :updated)
  end

  # DELETE /applications/:application_token/chats/:chat_number/messages/:number
  def destroy
    @message.destroy
    json_response({message: 'Message deleted successfully!'}, :deleted)
  end

  private

  def message_params
    params.permit(:body)
  end

  def set_application
    @application = Application.find_by_token(params[:application_id])
  end

  def set_application_chat
    @chat = @application.chats.find_by_number(params[:chat_id]) if @application.present?
  end

  def set_chat_message
    @message = @chat.messages.find_by_number(params[:id]) if @chat.present?
  end
end

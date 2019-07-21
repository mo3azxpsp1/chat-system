class MessageCreateWorker
  include Sidekiq::Worker

  def perform(no, chat_id, body)
    Message.create(number: no, chat_id: chat_id, body: body)
  end
end

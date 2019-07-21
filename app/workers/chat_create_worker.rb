class ChatCreateWorker
  include Sidekiq::Worker

  def perform(no, app_id)
    Chat.create(number: no, application_id: app_id)
  end
end

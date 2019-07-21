class Indexer
  include Sidekiq::Worker
  sidekiq_options queue: 'elasticsearch'

  Client = Elasticsearch::Client.new log: true, host: 'elasticsearch'

  def perform(operation, record_id)

    case operation.to_s
      when 'index'
        record = Message.find(record_id)
        Client.index  index: 'messages', type: 'message', id: record.id, body: record.__elasticsearch__.as_indexed_json
      when 'delete'
        Client.delete index: 'messages', type: 'message', id: record_id
      else raise ArgumentError, "Unknown operation '#{operation}'"
    end
  end
end
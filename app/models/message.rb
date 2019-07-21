class Message < ApplicationRecord

  include Elasticsearch::Model

  belongs_to :chat, inverse_of: :messages, counter_cache: true

  validates_presence_of :body

  validates :number, uniqueness: { scope: :chat_id, message: "number should be unique per chat" }, on: :new

  after_save  { Indexer.perform_async(:index,  self.id) } # index records asynchronously
  after_destroy { Indexer.perform_async(:delete, self.id) } # delete indexed records asynchronously


  # better to be separated in searchable module if we would include elasticseach in other models
  settings index: { number_of_shards: 1 } do
    mappings dynamic: 'false' do
      indexes :body, analyzer: 'english'
    end
  end

  def self.search(q)
    __elasticsearch__.search(
      {
        query: {
          query_string: {
            default_field: :body,
            query: "*#{q}*"
          }
        }
      }
    ).records
  end

end

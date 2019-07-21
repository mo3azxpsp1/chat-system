class Chat < ApplicationRecord
  belongs_to :application, inverse_of: :chats, counter_cache: true
  has_many :messages, dependent: :destroy, inverse_of: :chat

  validates_presence_of :number

  validates :number, uniqueness: { scope: :application_id, message: "number should be unique per application" }, on: :new

end

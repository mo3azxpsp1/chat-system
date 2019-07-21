class Application < ApplicationRecord
  has_many :chats, dependent: :destroy, inverse_of: :application

  before_validation :generate_token, on: :create

  validates_uniqueness_of :name, :token
  validates_presence_of :name, :token

  def generate_token
    self.token = SecureRandom.urlsafe_base64(24)
  end

end

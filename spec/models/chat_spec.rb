require 'rails_helper'

RSpec.describe Chat, type: :model do

  # Association test
  # ensure Chat model has a 1:m relationship with the Message model
  it { should have_many(:messages).dependent(:destroy).inverse_of(:chat) }
  # ensure Chat model belongs to Application model
  it { should belong_to(:application).inverse_of(:chats).counter_cache(true) }

  # Validation tests
  # ensure column number is present before saving
  it { should validate_presence_of(:number) }

  # ensure column number is unique per application
  it do
    chat1 = create(:chat)
    chat2 =  build(:chat, application_id: chat1.application_id, number: chat1.number)
    chat2.valid?(:new)
    chat2.errors.full_messages.should include("Number number should be unique per application")
  end

end
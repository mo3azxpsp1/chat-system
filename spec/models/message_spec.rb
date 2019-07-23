require 'rails_helper'

RSpec.describe Message, type: :model do

  it { expect belong_to(:chat).inverse_of(:messages).counter_cache(true) }

  it { expect validate_presence_of(:body) }

  it do
    msg1 = create(:message)
    msg2 =  build(:message, chat_id: msg1.chat_id, number: msg1.number)
    msg2.valid?(:new)
    msg2.errors.full_messages.should include("Number number should be unique per chat")
  end

  it "enqueues the Indexer on save" do
    expect(Indexer.jobs.size).to eq(0)
    msg = create(:message)
    expect(Indexer.jobs.size).to eq(1)
  end

  it "enqueues the Indexer on delete" do
    Message.skip_callback(:save, :after, :index_message)
    msg = create(:message)
    expect(Indexer.jobs.size).to eq(0)
    msg.destroy
    expect(Indexer.jobs.size).to eq(1)
  end
end
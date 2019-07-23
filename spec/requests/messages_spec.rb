require 'rails_helper'

RSpec.describe 'Messages API', type: :request do
  # initialize test data
  let!(:application) { create(:application) }
  let!(:chat) { create(:chat, application_id: application.id) }
  let!(:messages) { create_list(:message, 10, chat_id: chat.id) }
  let(:application_token) { application.token }
  let(:chat_number) { chat.number }
  let(:message_number) { messages.first.number }

  # Test suite for GET /applications/:application_token/chats/:chat_number/messgaes
  describe 'GET /applications/:application_token/chats/:chat_number/messages' do
    # make HTTP get request before each example
    before { get "/applications/#{application_token}/chats/#{chat_number}/messages" }

    it 'returns messages' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /applications/:application_token/chats/:chat_number/messages/:number
  describe 'GET /applications/:application_token/chats/:chat_number/messages/:number' do
    before { get "/applications/#{application_token}/chats/#{chat_number}/messages/#{message_number}" }

    context 'when the record exists' do
      it 'returns the message' do
        expect(json).not_to be_empty
        expect(json['number']).to eq(message_number)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:message_number) { 5333 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Not found/)
      end
    end
  end

  # Test suite for POST /applications/:application_token/chats/:chat_number/messages
  describe 'POST /applications/:application_token/chats/:chat_number/messages' do
    let(:valid_attributes) { { body: 'test message'} }

    context 'when the request is valid' do
      before { post "/applications/#{application_token}/chats/#{chat_number}/messages", params: valid_attributes }

      it 'returns a message number' do
        expect(json['message_number']).to eq(chat.messages.maximum(:number) + 1)
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end

      it { expect(MessageCreateWorker.jobs.size).to eq(1) }
    end

    context 'when the request is invalid' do
      before { post "/applications/#{application_token}/chats/#{chat_number}/messages", params: { body: '' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(JSON.parse(response.body)['errors'].first)
          .to match(/Body can't be blank/)
      end
    end
  end

  # Test suite for PUT /applications/:application_token/chats/:chat_number/messages/:number
  describe 'PUT /applications/:application_token/chats/:chat_number/messages/:number' do
    let(:valid_attributes) { { body: 'updated test message' } }

    context 'when the record exists' do
      before { put "/applications/#{application_token}/chats/#{chat_number}/messages/#{message_number}", params: valid_attributes }

      it 'updates the record' do
        expect(json).not_to be_empty
        expect(json['body']).to match(/updated test message/)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

  # Test suite for DELETE /applications/:application_token/chats/:chat_number/messages/:number
  describe 'DELETE /applications/:application_token/chats/:chat_number/messages/:number' do
    before { delete "/applications/#{application_token}/chats/#{chat_number}/messages/#{message_number}" }

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

end
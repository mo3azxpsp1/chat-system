require 'rails_helper'

RSpec.describe 'Chats API', type: :request do
  # initialize test data
  let!(:application) { create(:application) }
  let!(:chats) { create_list(:chat, 10, application_id: application.id) }
  let(:application_token) { application.token }
  let(:chat_number) { chats.first.number }

  # Test suite for GET /applications/:application_token/chats
  describe 'GET /applications/:application_token/chats' do
    # make HTTP get request before each example
    before { get "/applications/#{application_token}/chats" }

    it 'returns chats' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /applications/:application_token/chats/:number
  describe 'GET /applications/:application_token/chats/:number' do
    before { get "/applications/#{application_token}/chats/#{chat_number}" }

    context 'when the record exists' do
      it 'returns the chat' do
        expect(json).not_to be_empty
        expect(json['number']).to eq(chat_number)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:chat_number) { 3323 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Not found/)
      end
    end
  end

  # Test suite for POST /applications/:application_token/chats/
  describe 'POST /applications/:application_token/chats/' do

    context 'when the request is valid' do
      before { post "/applications/#{application_token}/chats" }

      it 'returns a chat number' do
        expect(json['chat_number']).to eq(application.chats.maximum(:number) + 1)
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end

      it { expect(ChatCreateWorker.jobs.size).to eq(1) }
    end

    context 'when the request is invalid' do
      before { post "/applications/7855fdfd5/chats" }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a validation failure message' do
        expect(JSON.parse(response.body)['error'])
          .to match(/Application not found/)
      end
    end
  end

  # Test suite for DELETE /applications/:application_token/chats/:number
  describe 'DELETE /applications/:application_token/chats/:number' do
    before { delete "/applications/#{application_token}/chats/#{chat_number}" }

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

end
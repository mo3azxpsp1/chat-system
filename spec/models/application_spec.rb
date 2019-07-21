require 'rails_helper'

# Test suite for the Application model
RSpec.describe Application, type: :model do

  # generate_token instance method test
  it 'verifies that the token is set' do
    expect(Application.count).to eq 0
    app = create(:application)
    expect(Application.count).to eq 1
    expect(app.token).not_to be_empty
  end

  # Association test
  # ensure Application model has a 1:m relationship with the Chat model
  it { should have_many(:chats).dependent(:destroy).inverse_of(:application) }

  # Validation tests
  # ensure columns name and token are present and unique before saving
  describe "presence" do
    it { should validate_presence_of(:name) }
    it do
      allow_any_instance_of(Application).to receive(:generate_token)
      should validate_presence_of(:token)
    end
  end

  describe "uniqueness" do
    subject { Application.new(name: "something", token: "something else") }
    it { should validate_uniqueness_of(:name) }
    it do
      allow_any_instance_of(Application).to receive(:generate_token)
      should validate_uniqueness_of(:token)
    end
  end
end
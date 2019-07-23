require 'rails_helper'

RSpec.describe ApplicationRecord, type: :model do

  # Overide as_json method test
  it 'excludes the id field from any returned record' do
    app = create(:application)
    expect(app.id).to be_present
    app = app.as_json
    expect(app['id']).not_to be_present
  end
end
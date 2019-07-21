FactoryBot.define do
  factory :chat do
    number { Faker::Number.number(1) }
    application_id { create(:application).id }
  end
end
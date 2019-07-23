FactoryBot.define do
  factory :chat do
    number { Faker::Number.unique.number(3) }
    application_id { create(:application).id }
  end
end
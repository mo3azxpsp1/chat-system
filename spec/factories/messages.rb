FactoryBot.define do
  factory :message do
    number { Faker::Number.unique.number(3) }
    chat_id { create(:chat).id }
    body { Faker::Lorem.sentence }
  end
end
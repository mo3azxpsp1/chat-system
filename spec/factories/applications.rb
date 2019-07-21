FactoryBot.define do
  factory :application do
    name { Faker::Lorem.word }
  end
end
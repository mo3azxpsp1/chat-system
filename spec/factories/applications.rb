FactoryBot.define do
  factory :application do
    name { Faker::Lorem.unique.word }
  end
end
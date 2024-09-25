# spec/factories/collections.rb
FactoryBot.define do
  factory :collection do
    name { Faker::Book.genre }
  end
end
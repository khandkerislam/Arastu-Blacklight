# spec/factories/subjects.rb
FactoryBot.define do
  factory :subject do
    name { Faker::Book.genre }
  end
end

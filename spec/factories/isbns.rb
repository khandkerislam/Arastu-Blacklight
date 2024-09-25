# spec/factories/isbns.rb
FactoryBot.define do
  factory :isbn do
    isbn { Faker::Code.isbn }
    association :book
  end
end
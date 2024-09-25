# spec/factories/authors.rb
FactoryBot.define do
  factory :author do
    full_name { Faker::Book.author }
  end
end
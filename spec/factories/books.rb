# spec/factories/books.rb
FactoryBot.define do
  factory :book do
    title { Faker::Book.title }
    processed { false }
    
    association :author, factory: :author
    association :collection, factory: :collection
    association :publisher, factory: :publisher

    after(:create) do |book|
      create_list(:isbn, 3, book: book)
      book.subjects << create_list(:subject, 2)
    end
  end

  factory :processed_book, parent: :book do 
    processed { true }
  end
end

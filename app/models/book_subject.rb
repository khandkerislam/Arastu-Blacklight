class BookSubject < ApplicationRecord
  belongs_to :book, dependent: :destroy
  belongs_to :subject, dependent: :destroy
end
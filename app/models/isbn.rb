class Isbn < ApplicationRecord
  belongs_to :book, dependent: :destroy
end

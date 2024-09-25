class Author < ApplicationRecord
  before_save :split_name

  has_many :books

  validates :full_name, presence: true

  private

  def split_name
    return if full_name.blank?

    parts = full_name.split(",").map(&:strip)
    self.last_name = parts[0]
    self.first_name = parts[1] || ""
  end
end

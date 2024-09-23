require 'rails_helper'

RSpec.describe Book, type: :model do
  it { should belong_to(:author).optional }
  it { should belong_to(:collection) }
  it { should belong_to(:publisher).optional }
  it { should have_many(:isbns)}
  it { should have_many(:book_subjects)}
  it { should have_many(:subjects).through(:book_subjects) }
end

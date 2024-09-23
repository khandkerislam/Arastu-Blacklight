require 'rails_helper'

RSpec.describe Subject, type: :model do
  it { should have_many(:book_subjects)}
  it { should have_many(:books).through(:book_subjects) }
end

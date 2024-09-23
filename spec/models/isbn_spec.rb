require 'rails_helper'

RSpec.describe Isbn, type: :model do
  it { should belong_to(:book) }
end

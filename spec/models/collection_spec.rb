require 'rails_helper'

RSpec.describe Collection, type: :model do
  it { should have_many(:books) }
end

require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many(:items)}
  end

  describe 'validations' do
    it { should validate_presence_of(:name)}
    it { should validate_uniqueness_of(:name)}
  end
end

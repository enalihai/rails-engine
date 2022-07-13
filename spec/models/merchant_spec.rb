require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many(:items)}
    it { should have_many(:invoices)}
    it { should have_many(:customers).through(:invoices)}
  end

  describe 'validations' do
    it { should validate_presence_of(:name)}
  end

  describe '.self#find_merchant' do
    it 'returns single merchant by alphbet::name/no case with partials'
  end

  describe '.self#find_all' do
    it 'returns all merchants alphabetically/no case with partials'
  end
end

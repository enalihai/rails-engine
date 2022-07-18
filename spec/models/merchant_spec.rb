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
    it 'returns single merchant by alphbet::name/no case with partials' do
      stephen = Merchant.create!(name: 'Stephens Shortstacks')
      madeleine = Merchant.create!(name: 'Madeleines Shoes')
      renee = Merchant.create!(name: 'Renees SHOP')
      luke = Merchant.create!(name: 'Lukes shop')
      mark = Merchant.create!(name: 'Showers by Mark')
      blaise = Merchant.create!(name: 'XYZ Doctors')
      query_params = 'Sho'

      merchant = Merchant.find_merchant(query_params)

      expect(merchant).to eq(luke)
      expect(merchant).to be_a(Merchant)
    end
  end

  describe '.self#find_all' do
    it '#find_item(query) returns single item by alphbet::name, no case, patrials included' do
      stephen = Merchant.create!(name: 'Stephens Shortstacks')
      madeleine = Merchant.create!(name: 'Madeleines Shoes')
      renee = Merchant.create!(name: 'Renees SHOP')
      luke = Merchant.create!(name: 'Lukes shop')
      mark = Merchant.create!(name: 'Showers by Mark')
      blaise = Merchant.create!(name: 'XYZ Doctors')

      merchants = Merchant.find_all_merchants('sho')

      expect(merchants.count).to eq(5)
      expect(merchants).to eq([luke, madeleine, renee, mark, stephen])
      expect(merchants).to_not include(blaise)
    end
  end 
end

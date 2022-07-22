require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to(:merchant)}
    it { should have_many(:invoice_items)}
    it { should have_many(:invoices).through(:invoice_items)}
  end

  describe 'validations' do
    it { should validate_presence_of(:name)}
    it { should validate_presence_of(:description)}
    it { should validate_presence_of(:unit_price)}
    it { should validate_presence_of(:merchant_id)}
  end

  describe '.self#' do
    it '#find::find_all?query returns single item by alphbet::name, no case' do
      merchant = create(:merchant)
      merchant_2 = create(:merchant)
      item_1 = merchant.items.create!({
        name: 'Candlestick',
        description: 'Holds your candles',
        unit_price: 40.05
      })
      item_2 = merchant.items.create!({
        name: 'desk',
        description: 'Holds your documents',
        unit_price: 38.85
      })
      item_3 = merchant.items.create!({
        name: 'Rope bag',
        description: 'Holds your rope',
        unit_price: 42.75
      })
      item_4 = merchant.items.create!({
        name: 'Gym bag',
        description: 'Holds your gym clothes',
        unit_price: 32.74
      })
      item_5 = merchant.items.create!({
        name: 'Overnight bag',
        description: 'Holds your clothes',
        unit_price: 38.44
      })
      item_6 = merchant_2.items.create!({
        name: 'Unhappy Meal',
        description: 'Lets you down hard',
        unit_price: 14.59
  })
      name = {name: 'BaG'}
      min_max_range = {min_price: 23.04, max_price: 41.45}
      max = {max_price: 41.45}
      
      named_item = Item.find_item(name)
      item_array = Item.find_all_items(name)
      
      test_array = []
      item_array.each {|item| test_array << item.name}
      
      expect(named_item).to eq(item_4)
      expect(test_array).to eq(['Gym bag', 'Overnight bag', 'Rope bag'])
      expect(item_array.count).to eq(3)
      
      expect(named_item).to be_an(Item)
      
      items_by_range = Item.items_within(min_max_range)
      max_item = Item.items_within(min_max_range).last
      min_item = Item.items_within(min_max_range).first
      
      test_array = []
      items_by_range.each {|item| test_array << item.name}
      
      expect(items_by_range.count).to eq(4)
      
      expect(min_item).to eq(item_4)
      expect(max_item).to eq(item_1)
      expect(min_item.unit_price).to eq(32.74)
      expect(max_item.unit_price).to eq(40.05)
      expect(min_item).to be_an(Item)
      expect(max_item).to be_an(Item)

      expect(test_array).to eq(["Gym bag", "Overnight bag", "desk", "Candlestick"])
    end
  end
end

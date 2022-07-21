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

  describe '.self#find' do
    it '#find_item(query) returns single item by alphbet::name, no case' do
      merchant = Merchant.create!(name: 'Test Merchant')
      merchant_2 = Merchant.create!(name: 'Sad Path')
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
        unit_price: 38.04
      })
      item_6 = merchant_2.items.create!({
        name: 'Unhappy Meal',
        description: 'Lets you down hard',
        unit_price: 14.59
      })

      query_params = {name: 'BaG'}
      item = Item.find_query(query_params)
      # add all the possible queries here and delete other tests
      expect(item).to eq(item_4)
      expect(item).to be_an(Item)
    end

    it '#find_min_price(min_int) returns single item closest to min price' do
    end 

    it '#find_max_price(max_int) returns single item closest to max price' do
      
    end
    
    it '#find_min_max(min_int, max_int) returns single item in range min_int -> max_int' do
      
    end
  end

  xdescribe '.self#find_all' do
    it '#items(query) :: array of items by alphbet::name, no case' do
      merchant = Merchant.create!(name: 'Test Merchant')
      merchant_2 = Merchant.create!(name: 'Sad Path')
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
        unit_price: 38.04
      })
      item_6 = merchant_2.items.create!({
        name: 'Unhappy Meal',
        description: 'Lets you down hard',
        unit_price: 14.59
      })

      query_params = {name: 'BaG'}

      item_array = Item.find_all_items(query_params)

      expect(item_array.count).to eq(3)
      expect(item_array).to eq([item_4, item_5, item_3])
    end

    it '#by_price(min_int, max_int): array of items in range min_int -> max_int' do
    end 
  end
end

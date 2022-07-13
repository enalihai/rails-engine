require 'rails_helper'

RSpec.describe 'Merchant and Item Search' do
  describe 'GET /items/find request' do
    before :each do
      @merchant = Merchant.create!(name: 'Test Merchant')
      @item_1 = @merchant.items.create!({
        name: 'Candlestick',
        description: 'Holds your candles',
        unit_price: 40.05
      })
      @item_2 = @merchant.items.create!({
        name: 'desk',
        description: 'Holds your documents',
        unit_price: 38.85
      })
      @item_3 = @merchant.items.create!({
        name: 'Rope bag',
        description: 'Holds your rope',
        unit_price: 42.75
      })
      @item_4 = @merchant.items.create!({
        name: 'Gym bag',
        description: 'Holds your gym clothes',
        unit_price: 32.74
      })
      @item_5 = @merchant.items.create!({
        name: 'Suitcase',
        description: 'Holds your clothes',
        unit_price: 38.04
      })
    end

    it 'returns single item that matches search term' do
      find_item_params = {name: 'desk'}
      headers = {'CONTENT_TYPE' => 'application/json'}

      get '/api/v1/items/find', headers: headers, params: find_item_params
      response_body = JSON.parse(response.body, symbolize_names: true)
      item = response.body

      expect(response).to be_successful
      expect(item).to have_key([:data])
      expect(item[:data]).to be_a(Hash)
      expect(item[:data]).to have_key([:attributes])

      item_attributes = item[:data][:attributes]

      expect(item_attributes).to have_key([:name])
      expect(item_attributes[:name]).to eq('desk')
      expect(item_attributes[:name]).to not_eq('Candlestick')
      expect(item_attributes[:name]).to not_eq('Rope bag')
      expect(item_attributes[:name]).to not_eq('Gym bag')
      expect(item_attributes[:name]).to not_eq('Suitcase')

      expect(item_attributes).to have_key([:description])
      expect(item_attributes[:description]).to eq('desk')
      expect(item_attributes[:description]).to not_eq('Candlestick')
      expect(item_attributes[:description]).to not_eq('Rope bag')
      expect(item_attributes[:description]).to not_eq('Gym bag')
      expect(item_attributes[:description]).to not_eq('Suitcase')

      expect(item_attributes).to have_key([:unit_price])
      expect(item_attributes[:unit_price]).to eq('desk')
      expect(item_attributes[:unit_price]).to not_eq('Candlestick')
      expect(item_attributes[:unit_price]).to not_eq('Rope bag')
      expect(item_attributes[:unit_price]).to not_eq('Gym bag')
      expect(item_attributes[:unit_price]).to not_eq('Suitcase')

      expect(item_attributes).to have_key([:merchant_id])
      expect(item_attributes[:merchant_id]).to eq(@merchant.id)
    end

    it 'allows to specify a name query parameter'
    it 'allows name: query parameter to be case insensitive'
    it '?min_price# should return equal to or greater than given price'
    it '?max_price# should return equal to or less than given price'
    it '?max_price=X&min_price=Y can use min and max price in query'
    it '?name=Name returns returns alphabetically'
    it 'allows to search by one or more price-related query parameters'
    it 'uses EITHER name param OR either/both price params'
    it 'uses BOTH name param AND either/both price params returns error'
  end

  describe 'GET /merchants/find request' do
    it 'single merchant that matches search term'
    it 'allows ?name which returns name and description'
    it 'allows ?name to be case insensitive'
    it '?name returns alphabetically'
  end

  describe 'GET /items/find_all request' do
    it 'items that match search term'
    it 'allows to specify a name query parameter'
    it 'allows name: query parameter to be case insensitive'
    it '?min_price# should return equal to or greater than given price'
    it '?max_price# should return equal to or less than given price'
    it '?max_price=X&min_price=Y can use min and max price in query'
    it '?name=Name returns all items alphabetically'
    it 'allows to search by one or more price-related query parameters'
    it 'uses EITHER name param OR either/both price params'
    it 'uses BOTH name param AND either/both price params returns error'
  end

  describe 'GET /merchants/find_all request' do
    it 'returns all merchants that match search term'
    it 'allows a name query parameter which returns name and description'
    it 'allows name: query parameter to be case insensitive'
    it '?name returns all matching merchants alphabetically'
  end
end

require 'rails_helper'

RSpec.describe 'Merchant and Item Search' do
  describe 'GET /items/find request' do
    it 'returns single item from case insensitive name query params' do
      merchant = Merchant.create!(name: 'Test Merchant')
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
        name: 'Suitcase',
        description: 'Holds your clothes',
        unit_price: 38.04
      })

      search_params = {name: 'DeSk'}
      headers = {'CONTENT_TYPE' => 'application/json'}

      get '/api/v1/items/find', headers: headers, params: search_params

      expect(response).to be_successful

      item = JSON.parse(response.body, symbolize_names: true)

      expect(item).to be_a(Hash)
      expect(item[:data].count).to eq(3)
      expect(item[:data][:type]).to eq('item')

      item_attributes = item[:data][:attributes]

      expect(item_attributes[:name]).to eq('desk')
      expect(item_attributes[:name]).to_not eq('Candlestick')
      expect(item_attributes[:name]).to_not eq('Rope bag')
      expect(item_attributes[:name]).to_not eq('Gym bag')
      expect(item_attributes[:name]).to_not eq('Suitcase')

      expect(item_attributes[:description]).to eq('Holds your documents')
      expect(item_attributes[:description]).to_not eq('Holds your candles')
      expect(item_attributes[:description]).to_not eq('Holds your rope')
      expect(item_attributes[:description]).to_not eq('Holds your gym clothes')
      expect(item_attributes[:description]).to_not eq('Holds your clothes')

      expect(item_attributes[:unit_price]).to eq(38.85)
      expect(item_attributes[:unit_price]).to_not eq(40.05)
      expect(item_attributes[:unit_price]).to_not eq(42.75)
      expect(item_attributes[:unit_price]).to_not eq(32.74)
      expect(item_attributes[:unit_price]).to_not eq(38.04)

      expect(item_attributes[:merchant_id]).to eq(merchant.id)
    end

    it 'returns an error object when name query=NOMATCH' do
      merchant = Merchant.create!(name: 'Test Merchant')
      item_1 = merchant.items.create!({
        name: 'Candlestick',
        description: 'Holds your candles',
        unit_price: 40.05
      })

      search_params = {name: 'Desk'}
      headers = {'CONTENT_TYPE' => 'application/json'}

      get '/api/v1/items/find', headers: headers, params: search_params

      expect(response).to be_successful

      item = JSON.parse(response.body, symbolize_names: true)

      expect(item[:data]).to be_a(Hash)
      expect(item[:data][:id]).to be_a(String)
      expect(item[:data][:title]).to be_a(String)
    end

    it '?name returns a single item alphabetically'
    it '?min_price# should return equal to or greater than given price'
    it '?max_price# should return equal to or less than given price'
    it '?max_price=X&min_price=Y can be used in query'
    it 'uses EITHER name param OR either/both price params'
    it 'uses BOTH name param AND either/both price params returns error'
  end

  describe 'GET /items/find_all request' do
    xit 'returns all items that match case insensitive query parameters' do
      merchant = Merchant.create!(name: 'Test Merchant')
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

      search_params = {name: 'BaG'}
      headers = {'CONTENT_TYPE' => 'application/json'}

      get '/api/v1/items/find_all', headers: headers, params: search_params

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items).to be_a(Hash)
      expect(items[:data]).to be_an(Array)
      # add more tests here after model AR / SQL
    end

    it '?name=Name returns all items alphabetically'
    it '?min_price# should return equal to or greater than given price'
    it '?max_price# should return equal to or less than given price'
    it '?max_price=X&min_price=Y can be used in query'
    it 'uses EITHER name param OR either/both price params'
    it 'uses BOTH name param AND either/both price params returns error'
  end

  describe 'GET /merchants/find request' do
    it 'single merchant from case insensitive name query params' do
      merchant_1 = Merchant.create!(name: 'Animal House')
      merchant_2 = Merchant.create!(name: 'Pangolier Pizza')
      merchant_3 = Merchant.create!(name: 'Bills BBQ')

      search_params = {name: 'pIzZa'}
      headers = {'CONTENT_TYPE' => 'application/json'}

      get '/api/v1/merchants/find', headers: headers, params: search_params

      expect(response).to be_successful

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(merchant[:data]).to be_a(Hash)
      expect(merchant[:data][:type]).to eq('merchant')
      expect(merchant[:data][:attributes]).to be_a(Hash)
      expect(merchant[:data][:attributes][:name]).to eq('Pangolier Pizza')
    end

    it 'returns an error object when name query=NOMATCH' do
      merchant_1 = Merchant.create!(name: 'Pangolier Pizza')
      merchant_2 = Merchant.create!(name: 'Angels Pasta')
      merchant_3 = Merchant.create!(name: 'Quick Dogs')

      search_params = {name: 'Raditz Ramen'}
      headers = {'CONTENT_TYPE' => 'application/json'}

      get '/api/v1/merchants/find', headers: headers, params: search_params

      expect(response).to be_successful

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(merchant[:data]).to be_a(Hash)
      expect(merchant[:data][:id]).to be_a(String)
      expect(merchant[:data][:title]).to be_a(String)
    end

    it '?name which returns name and description'
    it '?name returns alphabetically'
  end

  describe 'GET /merchants/find_all request' do
    xit 'all merchants from case insensitive name query params' do
      merchant_1 = Merchant.create!(name: 'Animal House')
      merchant_2 = Merchant.create!(name: 'Pangolier Pizza')
      merchant_3 = Merchant.create!(name: 'Bills BBQ')

      search_params = {name: 'pIzZa'}
      headers = {'CONTENT_TYPE' => 'application/json'}

      get '/api/v1/merchants/find_all', headers: headers, params: search_params

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants).to be_a(Hash)
      expect(merchants[:data]).to be_an(Array)
      # add more tests here after model AR/SQL
    end

    it '?name which returns name and description'
    it '?name returns alphabetically'
  end
end

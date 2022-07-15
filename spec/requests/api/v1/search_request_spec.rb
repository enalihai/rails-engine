require 'rails_helper'

RSpec.describe 'Merchant and Item Search' do
  describe 'GET /items/find' do
    it 'returns first item alphabetically::case insens query: :includes partial matches' do
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

      query_params = {name: 'DeSk'}
      headers = {'CONTENT_TYPE' => 'application/json'}

      get '/api/v1/items/find', headers: headers, params: query_params

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

    it '?min_price=query with price closest to >= min_price' do
      merchant = Merchant.create!(name: 'Test Merchant')
      item_1 = merchant.items.create!({
        name: 'Candlestick',
        description: 'Holds your candles',
        unit_price: 40.05
      })
      item_2 = merchant.items.create!({
        name: 'desk',
        description: 'Holds your documents',
        unit_price: 42.75
      })
      item_3 = merchant.items.create!({
        name: 'Rope bag',
        description: 'Holds your rope',
        unit_price: 38.85
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

      query_params = {min_price: 38.45}
      headers = {'CONTENT_TYPE' => 'application/json'}

      get '/api/v1/items/find', headers: headers, params: query_params

      expect(response).to be_successful

      min_item = JSON.parse(response.body, symbolize_names: true)

      expect(min_item).to be_a(Hash)
      expect(min_item[:data].count).to eq(3)
      expect(min_item[:data][:attributes].count).to eq(4)

      min_item = min_item[:data][:attributes]

      expect(min_item[:name]).to eq('Rope bag')
      expect(min_item[:name]).to_not eq('desk')
      expect(min_item[:unit_price]).to eq(38.85)
      expect(min_item[:unit_price]).to_not eq(40.05)
      expect(min_item[:unit_price]).to_not eq(42.75)
      expect(min_item[:unit_price]).to_not eq(32.74)
      expect(min_item[:unit_price]).to_not eq(38.04)
    end

    it '?max_price= return equal to or less than max_price'
    it 'uses EITHER name param OR either/both price params'
    it 'uses BOTH name param AND either/both price params returns error'
  end

  describe 'GET /items/find_all' do
    it 'returns array of items alphabetically::case insens query: :includes partial matches' do
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
      headers = {'CONTENT_TYPE' => 'application/json'}

      get '/api/v1/items/find_all', headers: headers, params: query_params

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)
  
      expect(items).to have_key(:data)
      expect(items[:data]).to be_a(Hash)
      # add more tests here after model AR / SQL
    end

    it '?min_price= return equal to or greater than min_price'
    it '?max_price= return equal to or less than max_price'
    it 'uses EITHER name param OR either/both price params'
  end

  describe 'GET /merchants/find?name=query' do
    it 'returns first merchant alphabetically from case insensitive name query' do
      merchant_1 = Merchant.create!(name: 'Animal Pizza')
      merchant_2 = Merchant.create!(name: 'Pangolier Pizza')
      merchant_3 = Merchant.create!(name: 'Bills BBQ')

      query_params = {name: 'pIzZa'}
      headers = {'CONTENT_TYPE' => 'application/json'}

      get '/api/v1/merchants/find', headers: headers, params: query_params

      expect(response).to be_successful

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(merchant[:data]).to be_a(Hash)
      expect(merchant[:data][:type]).to eq('merchant')
      expect(merchant[:data][:attributes]).to be_a(Hash)
      expect(merchant[:data][:attributes][:name]).to eq('Animal Pizza')
    end
  end

  describe 'GET /merchants/find_all?name=query' do
    it 'returns array alphabetically::case insensitive:includes partial matches' do
      merchant_1 = Merchant.create!(name: 'Pangolier Pizza')
      merchant_2 = Merchant.create!(name: 'Bills Pizza')
      merchant_3 = Merchant.create!(name: 'Rafis Ramen')
      merchant_4 = Merchant.create!(name: 'Animal Pizza')

      query_params = {name: 'pIzZa'}
      headers = {'CONTENT_TYPE' => 'application/json'}

      get '/api/v1/merchants/find_all', headers: headers, params: query_params

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data]).to be_an(Array)
      expect(merchants[:data].count).to eq(3)
      expect(merchants[:data][0][:attributes][:name]).to eq(merchant_4.name)
      expect(merchants[:data][1][:attributes][:name]).to eq(merchant_2.name)
      expect(merchants[:data][2][:attributes][:name]).to eq(merchant_1.name)
      expect(merchants[:data]).to_not include(merchant_3)
    end
  end

  describe 'EXTENSION #edge case / sad path testing' do

    it 'items#find?name returns error object for query=NOMATCH' do
      merchant = Merchant.create!(name: 'Test Merchant')
      item_1 = merchant.items.create!({
        name: 'Candlestick',
        description: 'Holds your candles',
        unit_price: 40.05
      })

      query_params = {name: 'zxyq'}
      headers = {'CONTENT_TYPE' => 'application/json'}

      get '/api/v1/items/find', headers: headers, params: query_params

      expect(response).to be_successful

      item = JSON.parse(response.body, symbolize_names: true)

      expect(item).to be_a(Hash)
      # expect(item[:data][:id]).to be_a(String)
      # expect(item[:data][:title]).to be_a(String)
    end

    it 'items#find_all?name returns error object for query=NOMATCH' do
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
      query_params = {name: 'zwkq'}
      headers = {'CONTENT_TYPE' => 'application/json'}

      get '/api/v1/items/find', headers: headers, params: query_params

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items).to be_a(Hash)
      # expect(items[:data][:id]).to be_a(String)
      # expect(items[:data][:title]).to be_a(String)
      # expect(items[:data][:title]).to eq('Invalid input: Formatting error')
    end

    it 'merchants#find?name returns error object for query=NOMATCH' do
      merchant_1 = Merchant.create!(name: 'Pangolier Pizza')
      merchant_2 = Merchant.create!(name: 'Angels Pasta')
      merchant_3 = Merchant.create!(name: 'Quick Dogs')

      query_params = {name: 'Raditz Ramen'}
      headers = {'CONTENT_TYPE' => 'application/json'}

      get '/api/v1/merchants/find', headers: headers, params: query_params

      expect(response.status).to eq(400)

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(merchant[:data]).to be_a(Hash)
      expect(merchant[:data][:id]).to be_a(String)
      expect(merchant[:data][:title]).to be_a(String)
    end

    it 'merchants#find_all?name returns error object for query=NOMATCH' do
      merchant_1 = Merchant.create!(name: 'Pangolier Pizza')
      merchant_2 = Merchant.create!(name: 'Angels Pasta')
      merchant_3 = Merchant.create!(name: 'Quick Dogs')

      query_params = {name: 'Raditz Ramen'}
      headers = {'CONTENT_TYPE' => 'application/json'}

      get '/api/v1/merchants/find', headers: headers, params: query_params

      expect(response.status).to eq(400)

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data]).to be_a(Hash)
      expect(merchants[:data][:id]).to be_a(String)
      expect(merchants[:data][:title]).to be_a(String)
      expect(merchants[:data][:title]).to eq('No results found for user input')
    end

    it '/items#find? using BOTH name param AND either/both price params returns error' do
      merchant = Merchant.create!(name: 'Test Merchant')
      item_1 = merchant.items.create!({
        name: 'Candlestick',
        description: 'Holds your candles',
        unit_price: 40.05
      })

      query_params = {name: 'Candlestick', min_price: 38.99}
      headers = {'CONTENT_TYPE' => 'application/json'}

      get '/api/v1/items/find', headers: headers, params: query_params

      expect(response.status).to eq(400)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error[:data]).to be_a(Hash)
      expect(error[:data][:id]).to eq('error')
      expect(error[:data][:title]).to eq('Invalid input: Formatting error')
    end

    it '/items#find_all using BOTH name param AND either/both price params returns error'

    it 'for any BLANK/Nil/invalid query_params returns specificied json error' do
      merchant = Merchant.create!(name: 'Test Merchant')
      item_1 = merchant.items.create!({
        name: 'Candlestick',
        description: 'Holds your candles',
        unit_price: 40.05
      })

      query_params = {name: ''}
      headers = {'CONTENT_TYPE' => 'application/json'}

      # binding.pry
      get '/api/v1/items/find', headers: headers, params: query_params

      # binding.pry

      expect(response.status).to eq(400)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error[:data]).to be_a(Hash)
      expect(error[:data][:id]).to eq('error')
      expect(error[:data][:title]).to eq('Invalid input: Formatting error')

      # get '/api/v1/items/find', headers: headers, params: query_params
      #
      # expect(response).to be_successful
      #
      # item = JSON.parse(response.body, symbolize_names: true)
      # expect(item[:data]).to be_a(Hash)
    end
  end
end

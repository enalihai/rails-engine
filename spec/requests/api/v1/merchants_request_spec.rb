require 'rails_helper'

RSpec.describe "Merchants API Request", type: :request do
  xdescribe 'GET /merchants/find?name=query' do
    it 'returns first merchant alphabetically from case insensitive name query' do
      merchant_1 = Merchant.create!(name: 'Animal Pizza')
      merchant_2 = Merchant.create!(name: 'Pangolier Pizza')
      merchant_3 = Merchant.create!(name: 'Bills BBQ')

      query_params = {name: 'pIzZa'}
      headers = {'CONTENT_TYPE' => 'application/json'}

      get '/api/v1/merchants/find', headers: headers, params: query_params

      expect(response.status).to eq(200)

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(merchant[:data]).to be_a(Hash)
      expect(merchant[:data][:type]).to eq('merchant')
      expect(merchant[:data][:attributes]).to be_a(Hash)
      expect(merchant[:data][:attributes][:name]).to eq('Animal Pizza')
    end
    
    it 'returns merchants#show by ID' do
      id = create(:merchant).id
      
      get "/api/v1/merchants/#{id}"
      merchant = JSON.parse(response.body, symbolize_names: true)
      
      expect(response.status).to eq(200)
      
      expect(merchant).to have_key(:data)
      expect(merchant[:data]).to have_key(:id)
      expect(merchant[:data]).to have_key(:type)
      expect(merchant[:data]).to have_key(:attributes)
      expect(merchant[:data][:attributes]).to be_a(Hash)
      expect(merchant[:data][:attributes][:name]).to be_a(String)
    end
  end

  xdescribe 'GET /merchants/find_all?name=query' do
    it 'returns array alphabetically::case insensitive:includes partial matches' do
      merchant_1 = Merchant.create!(name: 'Pangolier Pizza')
      merchant_2 = Merchant.create!(name: 'Bills Pizza')
      merchant_3 = Merchant.create!(name: 'Rafis Ramen')
      merchant_4 = Merchant.create!(name: 'Animal Pizza')
  
      query_params = {name: 'IzZa'}
      headers = {'CONTENT_TYPE' => 'application/json'}
  
      get '/api/v1/merchants/find_all', headers: headers, params: query_params
  
      expect(response.status).to eq(200)
  
      merchants = JSON.parse(response.body, symbolize_names: true)
  
      expect(merchants[:data]).to be_an(Array)
      expect(merchants[:data].count).to eq(3)
      expect(merchants[:data][0][:attributes][:name]).to eq(merchant_4.name)
      expect(merchants[:data][1][:attributes][:name]).to eq(merchant_2.name)
      expect(merchants[:data][2][:attributes][:name]).to eq(merchant_1.name)
      expect(merchants[:data]).to_not include(merchant_3)
    end

    it 'returns merchants#index' do
      create_list(:merchant, 5)
      get '/api/v1/merchants'
      
      expect(response.status).to eq(201)
      merchants = JSON.parse(response.body, symbolize_names: true)
      
      expect(merchants[:data].count).to eq(5)
      
      merchants[:data].each do |merchant|
        expect(merchant).to have_key(:id)
        expect(merchant[:id]).to be_an(String)
        
        expect(merchant).to have_key(:type)
        expect(merchant[:type]).to be_a(String)
        
        expect(merchant[:attributes]).to be_a(Hash)
        expect(merchant[:attributes][:name]).to be_a(String)
      end
    end
  end

  xdescribe 'GET /merchants/find?merchants/items' do
    it 'returns alphabetically::case insensitive : includes partials' do
      merchant1 = Merchant.create!(name: "Luke's Shop")
      merchant2 = Merchant.create!(name: "Stephen's Shop")
      item1 = merchant1.items.create!(description: "Breakfast food", name: "Waffles", unit_price: 21)
      item2 = merchant1.items.create!(description: "Lunch Food", name: "PBJ", unit_price: 13)
      item3 = merchant2.items.create!(description: "Dinner Food", name: "Steak", unit_price: 27)
      item4 = merchant2.items.create!(description: "Dessert food", name: "Ice Cream", unit_price: 7)
      
      get "/api/v1/merchants/#{merchant1.id}/items"
      
      expect(response.status).to eq(200)
      item_list = JSON.parse(response.body, symbolize_names: true)
      
      expect(item_list[:data].count).to eq(2)
      
      item_list[:data].each do |item|
        expect(item[:id]).to be_a(Integer)
        expect(item[:attributes][:name]).to be_a(String)
        expect(item[:attributes][:description]).to be_a(String)
        expect(item[:attributes][:unit_price]).to be_a(Float)
      end
    end
  end

  xdescribe 'EDGECASE merchants#find/find_all' do
    it 'find?query=NOMATCH :: name returns error status == 204' do
      merchant_1 = Merchant.create!(name: 'Pangolier Pizza')
      merchant_2 = Merchant.create!(name: 'Angels Pasta')
      merchant_3 = Merchant.create!(name: 'Quick Dogs')

      query_params = {name: 'Raditz Ramen'}
      headers = {'CONTENT_TYPE' => 'application/json'}

      get '/api/v1/merchants/find', headers: headers, params: query_params

      expect(response.status).to eq(204)
    end

    it 'find_all?query=NOMATCH :: name returns Error status == 204' do
      merchant_1 = Merchant.create!(name: 'Pangolier Pizza')
      merchant_2 = Merchant.create!(name: 'Angels Pasta')
      merchant_3 = Merchant.create!(name: 'Quick Dogs')

      query_params = {name: 'Raditz Ramen'}
      headers = {'CONTENT_TYPE' => 'application/json'}

      get '/api/v1/merchants/find_all', headers: headers, params: query_params

      expect(response.status).to eq(204)

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data]).to be_a(Array)
      expect(merchants[:data][:id]).to be_a(String)
      expect(merchants[:data][:title]).to be_a(String)
      expect(merchants[:data][:title]).to eq('No results found for user input')
    end

    it 'find?name.blank? errors :: return correct json' do
      merchant = Merchant.create!(name: 'Test Merchant')
      item_1 = merchant.items.create!({
        name: 'Candlestick',
        description: 'Holds your candles',
        unit_price: 40.05
      })

      blank_query = {name: ''}
      headers = {'CONTENT_TYPE' => 'application/json'}

      get '/api/v1/merchants/find', headers: headers, params: blank_query

      expect(response.status).to eq(404)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error[:data]).to be_a(Array)
      expect(error[:data][:id]).to eq(nil)
      expect(error[:data][:title]).to eq('Cannot search for blank or nil')
    end

    it 'find_all?name.blank? errors :: return correct json' do
      merchant = Merchant.create!(name: 'Test Merchant')
      item_1 = merchant.items.create!({
        name: 'Candlestick',
        description: 'Holds your candles',
        unit_price: 40.05
      })

      blank_query = {name: ''}
      headers = {'CONTENT_TYPE' => 'application/json'}

      get '/api/v1/merchants/find_all', headers: headers, params: blank_query

      expect(response.status).to eq(404)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error[:data]).to be_a(Hash)
      expect(error[:data][:id]).to eq(nil)
      expect(error[:data][:title]).to eq('error: null,
        title: "NOMATCH :: No matching results found in database!"')
    end

    it 'find?nil errors :: return correct json' do
      merchant = Merchant.create!(name: 'Test Merchant')
      item_1 = merchant.items.create!({
        name: 'Candlestick',
        description: 'Holds your candles',
        unit_price: 40.05
      })

      blank_query = {name: ''}
      headers = {'CONTENT_TYPE' => 'application/json'}

      get '/api/v1/merchants/find', headers: headers, params: blank_query

      expect(response.status).to eq(404)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error[:data]).to be_a(Hash)
      expect(error[:data][:id]).to eq(nil)
      expect(error[:data][:title]).to eq('error: null,
        title: "NIL :: Not a valid input!"')
    end
    
    it 'find_all?nil errors :: return correct json' do
      merchant = Merchant.create!(name: 'Test Merchant')
      item_1 = merchant.items.create!({
        name: 'Candlestick',
        description: 'Holds your candles',
        unit_price: 40.05
      })

      blank_query = {name: nil}
      headers = {'CONTENT_TYPE' => 'application/json'}

      get '/api/v1/merchants/find_all', headers: headers, params: blank_query

      expect(response.status).to eq(404)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error[:data]).to be_a(Hash)
      expect(error[:data][:id]).to eq(nil)
      xexpect(error[:data][:title]).to eq('error: null,
        title: "NOMATCH :: Not a valid input!"')
    end
  end
end
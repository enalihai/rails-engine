require 'rails_helper'

RSpec.describe 'EXTENSIONS # edge / sad path testing' do
  describe 'for items#find' do
    it '?query=NOMATCHname returns error object' do
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
    
    it '?min/max=float WITH ?name=string returns error' do
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
  end 

  describe 'for items#find_all' do
    it '?query=NOMATCHname :: returns error but status == 200' do
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

    it '?query=INVALID :: ?min/max WITH ?name returns error' do
    end
  end

  describe 'for merchants#find/find_all=' do
    it 'find?query=NOMATCH :: name returns error status == 200' do
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

    it 'find_all?query=NOMATCH :: name returns Error status == 200' do
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
  end

  describe 'for any BLANK/Nil/invalid query_params returns specificied json error' do
    it 'for all BLANK errors :: return correct json' do
      merchant = Merchant.create!(name: 'Test Merchant')
      item_1 = merchant.items.create!({
        name: 'Candlestick',
        description: 'Holds your candles',
        unit_price: 40.05
      })

      query_params = {name: ''}
      headers = {'CONTENT_TYPE' => 'application/json'}

      get '/api/v1/items/find', headers: headers, params: query_params

      expect(response.status).to eq(400)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error[:data]).to be_a(Hash)
      expect(error[:data][:id]).to eq('error')
      expect(error[:data][:title]).to eq('Invalid input: Formatting error')
    end

    # it 'for all NIL errors :: return correct json' do
    # end

    # it 'for all INVALID errors :: return correct json'do
    # end 
  end
end
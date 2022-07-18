require 'rails_helper'

RSpec.describe 'Edgecase Te' do


  describe 'EDGECASE / SADPATH' do
    it 'items#find?name=NOMATCH returns error' do
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

    it 'merchants#find?name=NOMATCH returns error' do
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

    it 'items#find_all?name=NOMATCH returns error' do
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

    it 'merchants#find_all?name=NOMATCH returns error' do
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

    it 'items#find? when query == :name && :min_price || :max_price' do
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

    it 'items#find_all? when query == :name && :min_price || :max_price' do
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

    it 'items#find/find_all? when :min_price = nil && :max_price = nil' do
      merchant = Merchant.create!(name: 'Test Merchant')
      item_1 = merchant.items.create!({
        name: 'Candlestick',
        description: 'Holds your candles',
        unit_price: 40.05
      })

      blank_prices = {min_price: '', max_price: ''}
      headers = {'CONTENT_TYPE' => 'application/json'}

      get '/api/v1/items/find', headers: headers, params: blank_prices

      expect(response.status).to eq(400)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error[:data]).to be_a(Hash)
      expect(error[:data][:id]).to eq('Invalid Input')
      expect(error[:data][:title]).to eq("BLANK :: Queries params can't be blank!")
    end

    it 'value?query =BLANK || =nil || =INVALID :: return specific errors' do
      merchant = Merchant.create!(name: 'Test Merchant')
      item_1 = merchant.items.create!({
        name: 'Candlestick',
        description: 'Holds your candles',
        unit_price: 40.05
      })

      blank_name = {name: ''}
      headers = {'CONTENT_TYPE' => 'application/json'}

      get '/api/v1/items/find', headers: headers, params: blank_name

      expect(response.status).to eq(400)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error[:data]).to be_a(Hash)
      expect(error[:data][:id]).to eq('Invalid Input')
      expect(error[:data][:title]).to eq("BLANK :: Queries params can't be blank!")

      # blank_range = {}
      # headers = {'CONTENT_TYPE' => 'application/json'}

      # get '/api/v1/items/find', headers: headers, params: blank_range

      # expect(response.status).to eq(400)

      # error = JSON.parse(response.body, symbolize_names: true)

      # expect(error[:data]).to be_a(Hash)
      # expect(error[:data][:id]).to eq('error')
      # expect(error[:data][:title]).to eq('')

      # nil_params = {name: nil}
      # headers = {'CONTENT_TYPE' => 'application/json'}

      # get '/api/v1/items/find', headers: headers, params: nil_params

      # expect(response.status).to eq(400)

      # error = JSON.parse(response.body, symbolize_names: true)

      # expect(error[:data]).to be_a(Hash)
      # expect(error[:data][:id]).to eq('null')
      # expect(error[:data][:title]).to eq("UNKNOWN :: Query params are invalid for search!")

      # invalid_params = {min_price: 51.45, max_price: 35.21}
      # headers = {'CONTENT_TYPE' => 'application/json'}

      # get '/api/v1/items/find', headers: headers, params: nil_params

      # expect(response.status).to eq(400)

      # error = JSON.parse(response.body, symbolize_names: true)

      # expect(error[:data]).to be_a(Hash)
      # expect(error[:data][:id]).to eq('Invalid Format')
      # expect(error[:data][:title]).to eq("MIN>MAX => :: min_price cant be greater than max_price!")
    end
  end
end
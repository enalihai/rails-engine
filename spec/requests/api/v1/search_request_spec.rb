require 'rails_helper'

RSpec.describe 'Merchant and Item Search' do
  xdescribe 'GET /items/find' do
    it '?name=valid :: a->z, any case, partials included' do
      merchant = Merchant.create!(name: 'Test Merchant')
      item_1 = merchant.items.create!({
        name: 'Candlestick',
        description: 'Holds your candles',
        unit_price: 40.05
      })
      item_2 = merchant.items.create!({
        name: 'wooden dEsk',
        description: 'Holds your computer',
        unit_price: 38.04
      })
      item_3 = merchant.items.create!({
        name: 'Rope bag',
        description: 'Holds your rope',
        unit_price: 42.75
      })
      item_4 = merchant.items.create!({
        name: 'glass dEsk',
        description: 'Holds your documents',
        unit_price: 38.85
      })
      item_5 = merchant.items.create!({
        name: 'Gym bag',
        description: 'Holds your gym clothes',
        unit_price: 32.74
      })

      query = {name: 'DeSk'}
      headers = {'CONTENT_TYPE' => 'application/json'}

      get '/api/v1/items/find', headers: headers, params: query

      expect(response.status).to eq(200)

      item = JSON.parse(response.body, symbolize_names: true)

      expect(item).to be_a(Hash)
      expect(item[:data].count).to eq(3)
      expect(item[:data][:type]).to eq('item')

      item_attributes = item[:data][:attributes]

      expect(item_attributes[:name]).to eq('glass dEsk')
      expect(item_attributes[:name]).to_not eq('wooden dEsk')
      expect(item_attributes[:name]).to_not eq('Candlestick')
      expect(item_attributes[:name]).to_not eq('Rope bag')
      expect(item_attributes[:name]).to_not eq('Gym bag')

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

    it '?min_price=valid :: where unit_price >= min_price' do
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

      min = {min_price: 38.45}
      headers = {'CONTENT_TYPE' => 'application/json'}

      get '/api/v1/items/find', headers: headers, params: min

      expect(response).to be_successful

      min_item = JSON.parse(response.body, symbolize_names: true)

      expect(min_item).to be_a(Hash)
      expect(min_item[:data].count).to eq(3)
      expect(min_item[:data][:attributes].count).to eq(4)

      min_item = min_item[:data][:attributes]

      expect(min_item[:name]).to eq('Rope bag')
      expect(min_item[:name]).to_not eq('Candlestick')
      expect(min_item[:unit_price]).to eq(38.85)
      expect(min_item[:unit_price]).to_not eq(40.05)
      expect(min_item[:unit_price]).to_not eq(42.75)
      expect(min_item[:unit_price]).to_not eq(32.74)
      expect(min_item[:unit_price]).to_not eq(38.04)
    end

    it '?max_price=valid :: where unit_price <= max_price' do
      merchant = Merchant.create!(name: 'Test Merchant')
      item_1 = merchant.items.create!({
        name: 'Candlestick',
        description: 'Holds your candles',
        unit_price: 37.42
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

      params = {max_price: 38.43}
      headers = {"CONTENT_TYPE" => "application/json"}

      get '/api/v1/items/find', headers: headers, params: params[:max_price]

      expect(response).to be_successful

      max_params = JSON.parse(response.body, symbolize_names: true)

      expect(max_params).to be_a(Hash)
      expect(max_params[:data].count).to eq(3)
      expect(max_params[:data][:attributes].count).to eq(4)

      max_item = max_params[:data][:attributes]

      expect(max_item[:name]).to eq('Suitcase')
      expect(max_item[:name]).to_not eq('desk')
      expect(max_item[:unit_price]).to eq(38.04)
      expect(max_item[:unit_price]).to_not eq(38.85)
      expect(max_item[:unit_price]).to_not eq(40.05)
      expect(max_item[:unit_price]).to_not eq(42.75)
      expect(max_item[:unit_price]).to_not eq(32.74)
    end

    it '?range=valid :: with [:name] || [:min_price, :max_price]' do
      merchant = Merchant.create!(name: 'Test Merchant')
      item_1 = merchant.items.create!({
        name: 'Candlestick',
        description: 'Holds your candles',
        unit_price: 37.42
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

      pricerange = {min_price: 38.00, max_price: 41.43}

      headers = {"CONTENT_TYPE" => "application/json"}

      get '/api/v1/items/find', headers: headers, params: pricerange

      expect(response.status).to eq(200)

      name = {name: "candle"}

      headers = {"CONTENT_TYPE" => "application/json"}

      get '/api/v1/items/find', headers: headers, params: name

      expect(response.status).to eq(200)

      min_name = {name: 'Min', min_price: 28.86}
      headers = {"CONTENT_TYPE" => "application/json"}

      get '/api/v1/items/find', headers: headers, params: min_name

      expect(response.status).to eq(400)

      max_name = {name: 'Max', min_price: 28.86}
      headers = {"CONTENT_TYPE" => "application/json"}

      get '/api/v1/items/find', headers: headers, params: max_name

      expect(response.status).to eq(400)

      min_max_name = {name: 'Name and Min', min_price: 28.86, max_price: 40.06}
      headers = {"CONTENT_TYPE" => "application/json"}

      get '/api/v1/items/find', headers: headers, params: params

      expect(response.status).to eq(400)
    end
  end

  xdescribe 'GET /items/find_all' do
    it '?name=valid :: a->z, any case, partials included' do
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

    it '?min_price=valid :: where unit_price >= min_price' do
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

      min = {min_price: 38.45}
      headers = {'CONTENT_TYPE' => 'application/json'}

      get '/api/v1/items/find_all', headers: headers, params: min

      expect(response.status).to eq(200)

      mins_array = JSON.parse(response.body, symbolize_names: true)

      expect(mins_array).to be_a(Hash)
      binding.pry
      expect(mins_array[:data].count).to eq(3)
      expect(mins_array[:data][:attributes].count).to eq(4)

      items_attr = mins_array[:data][:attributes]

      expect(items_attr[:name].count).to be(3)
      expect(items_attr[:name][0]).to eq('Rope bag')

      items_attr.each do |attr|
        expect(attr[:name].type).to be_a(String)
        expect(attr[:description].type).to be_a(String)
        expect(attr[:unit_price].type).to be_a(Number)
      end



      expect(item__attr[:unit_price]).to eq(38.85)

      # expect(min_array_attr[:name]).to_not eq('Candlestick')
      # expect(min_array_attr[:unit_price]).to_not eq(40.05)
      # expect(min_array_attr[:unit_price]).to_not eq(42.75)
      # expect(min_array_attr[:unit_price]).to_not eq(32.74)
      # expect(min_array_attr[:unit_price]).to_not eq(38.04)
    end

    it '?max_price=valid :: where unit_price <= max_price' do
      merchant = Merchant.create!(name: 'Test Merchant')
      item_1 = merchant.items.create!({
        name: 'Candlestick',
        description: 'Holds your candles',
        unit_price: 37.42
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

      params = {max_price: 38.43}
      headers = {"CONTENT_TYPE" => "application/json"}

      get '/api/v1/items/find_all', headers: headers, params: params

      expect(response).to be_successful

      max_params = JSON.parse(response.body, symbolize_names: true)

      expect(max_params).to be_a(Hash)
      expect(max_params[:data].count).to eq(3)
      expect(max_params[:data][:attributes].count).to eq(4)

      max_item = max_params[:data][:attributes]

      expect(max_item[:name]).to eq('Suitcase')
      expect(max_item[:name]).to_not eq('desk')
      expect(max_item[:unit_price]).to eq(38.04)
      expect(max_item[:unit_price]).to_not eq(38.85)
      expect(max_item[:unit_price]).to_not eq(40.05)
      expect(max_item[:unit_price]).to_not eq(42.75)
      expect(max_item[:unit_price]).to_not eq(32.74)
    end

    it '?range=valid :: with [:name] || [:min_price, :max_price]' do
      merchant = Merchant.create!(name: 'Test Merchant')
      item_1 = merchant.items.create!({
        name: 'Candlestick',
        description: 'Holds your candles',
        unit_price: 37.42
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

      pricerange = {min_price: 38.00, max_price: 41.43}

      headers = {"CONTENT_TYPE" => "application/json"}

      get '/api/v1/items/find_all', headers: headers, params: pricerange

      expect(response.status).to eq(200)

      name = {name: "candle"}

      headers = {"CONTENT_TYPE" => "application/json"}

      get '/api/v1/items/find_all', headers: headers, params: name

      expect(response.status).to eq(200)

      min_name = {name: 'Min', min_price: 28.86}
      headers = {"CONTENT_TYPE" => "application/json"}

      get '/api/v1/items/find_all', headers: headers, params: min_name

      expect(response.status).to eq(400)

      max_name = {name: 'Max', min_price: 28.86}
      headers = {"CONTENT_TYPE" => "application/json"}

      get '/api/v1/items/find_all', headers: headers, params: max_name

      expect(response.status).to eq(400)

      min_max_name = {name: 'Name and Min', min_price: 28.86, max_price: 40.06}
      headers = {"CONTENT_TYPE" => "application/json"}

      get '/api/v1/items/find_all', headers: headers, params: params

      expect(response.status).to eq(400)
    end
  end

  describe 'GET /merchants/find' do
    it '?name=valid :: a->z, any case, partials included' do
      merchant_1 = Merchant.create!(name: 'Pangolier Pizza')
      merchant_2 = Merchant.create!(name: 'Wills Pizza')
      merchant_3 = Merchant.create!(name: 'Animal Pizza')
      merchant_4 = Merchant.create!(name: 'Bills BBQ')

      query_params = 'piZZ'
      headers = {'CONTENT_TYPE' => 'application/json'}

      get '/api/v1/merchants/find', headers: headers, params: query_params

      expect(response.status).to eq(200)

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(merchant[:data]).to be_a(Hash)
      expect(merchant[:data][:type]).to eq('merchant')
      expect(merchant[:data][:attributes]).to be_a(Hash)
      expect(merchant[:data][:attributes][:name]).to eq('Animal Pizza')
    end
  end

  xdescribe 'GET /merchants/find_all' do
    it '?name=valid :: a->z, any case, partials included' do
      merchant_1 = Merchant.create!(name: 'Pangolier Pizza')
      merchant_2 = Merchant.create!(name: 'Bills Pizza')
      merchant_3 = Merchant.create!(name: 'Rafis Ramen')
      merchant_4 = Merchant.create!(name: 'Animal Pizza')

      query_params = {name: 'IzZa'}
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

      blank_range = {}
      headers = {'CONTENT_TYPE' => 'application/json'}
#if range params are blank it should return error if both are blank for :min :max
      get '/api/v1/items/find', headers: headers, params: blank_range

      expect(response.status).to eq(400)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error[:data]).to be_a(Hash)
      expect(error[:data][:id]).to eq('error')
      expect(error[:data][:title]).to eq('')

      nil_params = {name: nil}
      headers = {'CONTENT_TYPE' => 'application/json'}

      get '/api/v1/items/find', headers: headers, params: nil_params

      expect(response.status).to eq(400)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error[:data]).to be_a(Hash)
      expect(error[:data][:id]).to eq('null')
      expect(error[:data][:title]).to eq("UNKNOWN :: Query params are invalid for search!")

      invalid_params = {min_price: 51.45, max_price: 35.21}
      headers = {'CONTENT_TYPE' => 'application/json'}

      get '/api/v1/items/find', headers: headers, params: nil_params

      expect(response.status).to eq(400)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error[:data]).to be_a(Hash)
      expect(error[:data][:id]).to eq('Invalid Format')
      expect(error[:data][:title]).to eq("MIN>MAX => :: min_price cant be greater than max_price!")
    end
  end
end

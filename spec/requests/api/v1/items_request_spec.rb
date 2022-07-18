require 'rails_helper'

RSpec.describe 'Item API' do
  describe 'GET requests' do
    it 'returns the index of the items and checks their attributes' do
      merchant = create(:merchant)
      create_list(:item, 10, merchant_id: merchant.id)
      get '/api/v1/items'

      expect(response).to be_successful
      items = JSON.parse(response.body, symbolize_names: true)

      expect(items).to have_key(:data)
      expect(items[:data].count).to eq(10)

      items[:data].each do |item|
        expect(item).to have_key(:id)
        expect(item).to have_key(:type)
        expect(item).to have_key(:attributes)

        expect(item[:attributes]).to be_a(Hash)
        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_a(String)
        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_a(String)
        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_a(Float)
        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).to be_an(Integer)
      end
    end

    it 'returns a single item based on id query and checks their keys' do
      merchant = create(:merchant)
      item_id = create(:item, merchant_id: merchant.id).id

      get "/api/v1/items/#{item_id}"

      item = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(item[:data][:attributes]).to be_a(Hash)
      expect(item[:data][:attributes]).to have_key(:name)
      expect(item[:data][:attributes][:name]).to be_a(String)
      expect(item[:data][:attributes]).to have_key(:description)
      expect(item[:data][:attributes][:description]).to be_a(String)
      expect(item[:data][:attributes]).to have_key(:unit_price)
      expect(item[:data][:attributes][:unit_price]).to be_a(Float)
      expect(item[:data][:attributes]).to have_key(:merchant_id)
      expect(item[:data][:attributes][:merchant_id]).to be_an(Integer)
    end

    it 'checks for a blank return' do
      get '/api/v1/items'

      expect(response).to be_successful
      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq(0)
    end

    it 'can return the items merchant' do
      merchant = create(:merchant)
      item = create(:item, merchant_id: merchant.id)

      get "/api/v1/items/#{item.id}/merchant"
      merchant_info = JSON.parse(response.body, symbolize_names: true)

      expect(merchant_info[:data].count).to eq(3)
      expect(merchant_info[:data][:id]).to eq("#{merchant.id}")
      expect(merchant_info[:data][:attributes][:name]).to eq("#{merchant.name}")
    end
  end

  describe 'POST requests' do
    it 'can create a new item for a merchant' do
      merchant = Merchant.create!(name: 'Kona and Hazel')
      item_params = ({
        "name": 'Quick-Crete',
        "description": 'settles in fast!',
        "unit_price": 40.05,
        "merchant_id": merchant.id
        })
      headers = {"CONTENT_TYPE" => 'application/json'}
      post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)
      item = Item.last

      expect(response).to be_successful
      expect(item[:id]).to be_an(Integer)
      expect(item[:description]).to eq('settles in fast!')
      expect(item[:unit_price]).to eq(40.05)
      expect(item[:merchant_id]).to be_an(Integer)
    end

    it 'can destroy an item' do
      merchant = create(:merchant)
      item = create(:item, merchant_id: merchant.id)
      expect(Item.last).to eq(item)

      delete "/api/v1/items/#{item.id}"

      expect(Item.count).to eq(0)
      expect(response).to be_successful
      expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'deletes an invoice after destroy if no items remain'

    it 'can update an items attributes' do
      merchant = create(:merchant)
      item = create(:item, merchant_id: merchant.id)
      first_name = Item.last.name
      new_name_params = {name: 'Quick-Crete'}
      headers = {"CONTENT_TYPE" => 'application/json'}

      patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate({item: new_name_params})
      item = Item.find_by(id: item.id)

      expect(response).to be_successful
      expect(item.name).to_not eq(first_name)
      expect(item.name).to eq('Quick-Crete')
    end

    it 'returns a 404 if update doesnt correct patch' do
      merchant = create(:merchant)
      item = create(:item, merchant_id: merchant.id)
      first_name = Item.last.name
      new_item_params = {name: 'Dog Collar', merchant_id: "xyz"}
      headers = {"CONTENT_TYPE" => 'application/json'}
      patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate({item: new_item_params})

      expect(response).to have_http_status(404)
    end
  end

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
end
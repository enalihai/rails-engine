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

    it 'returns a single item based on id and checks their keys' do
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

    it 'deletes an invoice if no items remain'

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
end

require 'rails_helper'

RSpec.describe 'Item API' do
  describe 'GET requests' do
    it 'returns the index of the items and checks their attributes' do
      create_list(:item, 10)
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
      id = create(:item).id
      get "/api/v1/items/#{id}"
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

    it 'can return the item merchant'
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
      expect(item[:id]).to eq(12)
      expect(item[:description]).to eq('settles in fast!')
      expect(item[:unit_price]).to eq(40.05)
      expect(item[:merchant_id]).to eq(13)
    end

    it 'can destroy an item' do
      item = create(:item)
      expect(Item.last).to eq(item)

      delete "/api/v1/items/#{item.id}"

      expect(Item.count).to eq(0)
      expect(response).to be_successful
      expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'can update an items attributes' do
      merchant = Merchant.create!(name: 'Hazel and Kona')
      item = create(:item)
      first_name = Item.last.name
      new_name_params = {name: 'Quick-Crete'}
      headers = {"CONTENT_TYPE" => 'application/json'}

      patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate({item: new_name_params})
      item = Item.find_by(id: item.id)

      expect(response).to be_successful
      expect(item.name).to_not eq(first_name)
      expect(item.name).to eq('Quick-Crete')
    end
  end
end

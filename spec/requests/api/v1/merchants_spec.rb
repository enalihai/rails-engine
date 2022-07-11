require 'rails_helper'

RSpec.describe "Merchants API", type: :request do
  describe 'GET requests' do
    it 'returns the index of merchants' do
      create_list(:merchant, 5)
      get '/api/v1/merchants'

      expect(response).to be_successful
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

    it 'returns the show page for a single merchant' do
      id = create(:merchant).id

      get "/api/v1/merchants/#{id}"
      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful

      expect(merchant).to have_key(:data)
      expect(merchant[:data]).to have_key(:id)
      expect(merchant[:data]).to have_key(:type)
      expect(merchant[:data]).to have_key(:attributes)
      expect(merchant[:data][:attributes]).to be_a(Hash)
      expect(merchant[:data][:attributes][:name]).to be_a(String)
    end

    it 'can return a merchants items' do
      merchant1 = Merchant.create!(name: "Luke's Shop")
      merchant2 = Merchant.create!(name: "Stephen's Shop")
      item1 = merchant1.items.create!(description: "Breakfast food", name: "Waffles", unit_price: 21)
      item2 = merchant1.items.create!(description: "Lunch Food", name: "PBJ", unit_price: 13)
      item3 = merchant2.items.create!(description: "Dinner Food", name: "Steak", unit_price: 27)
      item4 = merchant2.items.create!(description: "Dessert food", name: "Ice Cream", unit_price: 7)

      get "/api/v1/merchants/#{merchant1.id}/items"

      expect(response).to be_successful
      item_list = JSON.parse(response.body, symbolize_names: true)

      expect(item_list[:data].count).to eq(2)

      item_list[:data].each do |item|
        expect(item[:id]).to be_a(String)
        expect(item[:attributes][:name]).to be_a(String)
        expect(item[:attributes][:description]).to be_a(String)
        expect(item[:attributes][:unit_price]).to be_a(Float)
      end
    end
  end
end

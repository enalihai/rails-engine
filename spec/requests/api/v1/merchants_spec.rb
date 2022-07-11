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
  end
end

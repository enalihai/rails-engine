require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to(:merchant)}
    it { should have_many(:invoice_items)}
    it { should have_many(:invoices).through(:invoice_items)}
  end

  describe 'validations' do
    it { should validate_presence_of(:name)}
    it { should validate_presence_of(:description)}
    it { should validate_presence_of(:unit_price)}
  end

  describe '.self#find' do
    it '#find_item(query) returns single item by alphbet::name, no case'
    it '#find_min_price(min_int) returns single item closest to min price'
    it '#find_max_price(max_int) returns single item closest to max price'
    it '#find_min_max(min_int, max_int) returns single item in range min_int -> max_int'
  end

  describe '.self#find_all' do
    it '#find_all_items(query): array of items by alphbet::name, no case'
    it '#find_all_min(min_int): array of items >= min price'
    it '#find_all_max(max_int): array of items <= max price'
    it '#find_all_min_max(min_int, max_int): array of items in range min_int -> max_int'
  end
end
